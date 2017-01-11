From: Florian Westphal <fw@strlen.de>
Subject: nftables conntrack set ops for zone, helper assignment, etc.
Date: Wed, 11 Jan 2017 10:17:21 +0100
Message-ID: <20170111091721.GA26703@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: christophe.leroy@c-s.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58932 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756004AbdAKJR2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2017 04:17:28 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ CCing Christophe wrt. nft helper assigment ]

Hi.

to make bridge conntrack a reality I need a way to assign packets to conntrack zones.

Whatever solution is chosen, it should allow to eventually implement all of the CT
target features, namely:
       --helper name
       --ctevents event[,...]
       --expevents event[,...]
       --zone-orig {id|mark}
       --zone-reply {id|mark}
       --zone {id|mark}
       --timeout name

Unfortunately, its not that simple to do this with nft.
With CT target, all options are passed to single CT instance so all
information is available at checkentry (config) time.

Once the target function was run, skb->nfct is set to the template,
next -j CT (if any) is a no-op (XT_CONTINUE if skb->nfct != NULL).

For nft, it would be nice to use the 'set' syntax, i.e.

nft ... ct helper set ftp
nft ... ct zone set 4
nft ... ct timeout set policyname
nft ... ct ctevents set new|destroy|mark   [1]

Seems simple enough.  BUT:
now consider case where we want to set both helper and zone:

nft ... ct helper set ftp ct zone set 4

nft_ct only works with a single key, and we have no way to "propagate"
or "chain" the helper and the zone set operation.

We also don't know that the 'ct zone set 4' is the 'last' action,
where we're "done" with said skb (i.e. skb->nfct template is fully
set up the way we want).

Now, lets consider using nft features like maps:

nft ... ct zone set vlan id map { 1 : 1, 2 : 2, }
nft ... ct original zone set meta mark
nft ... ct helper set tcp dport map { 21 : ftp, 2121 : ftp, 12345 : sip }

... which would require that template instantiation happens from packet
path.

I'd argue that #3 above is not all that important but ability to set
zone from mark, vlan id etc at runtime seems too nice to ignore.

I've thought about ways to implement this.

AFAICS, zone id is the only attribute that needs to be propagated and
used in nf_conntrack_in() [because it influences conntrack lookup].

All other attibutes could be done at any later point in time provided it
occurs before ct confirmation, i.e. we could operate on the actual conntrack
and not a template.

So, I propose following solution:

nft_ct gets two new ops:

1) a template set op, used when we have sreg + ZONE key (zone key is to be
added).

2) a 'unconfirmed set' op, used when we have sreg and
one of timeout, helper, ctevents, expevents key (the latter two don't exist
either yet could be added easily).

This assumes that allmost all ct keys are readonly for confirmed/real
conntracks, otherwise we'd need syntax to indicate that we want to operate
on template/unconfirmed entry (plus netlink flag to indicate this to
kernel).

For 1), eval would work similar to this:
  fetch skb->nfct.
  If its a valid conntrack, bail (nothing to do).

  If its NULL, attach a percpu template scratch space iff
  that template scratch space has refcount of one.
  Otherwise, need to allocate fresh copy (we would not
  have this problem if we disallow nfqueue of nfct templates but I don't
  see how this could be done without compat breakage).
  Alternatively we could force this duplication in the nfqueue backend
  or disallow queueing skbs where nfct is a template.

In pseudocode:
template_unused(nfct):
  return refcount(nfct) == 1;

eval(skb):
 nfct = skb->nfct;
 if (!nfct) {
    nfct = percpu(this_template);
    if (!template_unused(tmpl)))
       nfct = ALLOC();

 /* nfct now either percpu cached object or newly alloc'd */
 nfct->zone = value;
 inc_refcount(nfct);
 skb->nfct = nfct;

For 2), do following:
 fetch skb->nfct.  If its a confirmed conntrack and key set operation
 works with confirmed conntracks, do the set op, else bail (can't
 expand/change extension area for confirmed ones, but ctevent mask
 manipulation would work for instance).
 If its NULL or a template, call nf_conntrack_in to obtain skb->nfct

 If still NULL, bail (invalid skb).  Otherwise, do the set operation.

 In pseudocode:
 doit(skb, key, value):
   if key == helper:
	if skb->nfct is unconfirmed:
	  add helper extension and return

   else set key/value of skb->nfct

 eval(skb):
   if (skb->nfct == NULL or template)
	skb->nfct = nf_conntrack_in(skb, ...)
	if (skb->nfct != NULL)
	  doit(skb)
   else
     doit(skb)

Problems with above approach:

1).  nft ct $key set $expr

... would behave differently depending on the key:

Zone key would not work for real conntracks (can't change zone at later
point).
Other keys would do conntrack lookups and assign skb->nfct. I think we
could change existing label/mark set support to perform a conntrack
lookup too if conntrack is not yet assigned to alleviate this, otherwise
it might be a bit confusion to users...

2). The templating scheme used now is rather unfriendly when
we need to reset the percpu scratch space. Not a big deal if we
only have to cope with zones since that no longer uses the extension area,
i.e. our template object would really just be a very bloated way to
pass the zone information.

3). nfqueue.  We can infer its presence with refcount test
on the percpu template, if its > 1, template is still assigned to another
skb.  If it happens we eat cost of additional kmalloc/free.
I think this isn't a big deal though.

4). Doing helper and template assignment requires lookups in packet path,
however I think we can make such lookups faster if needed and it would
only happen for unconfirmed/new conntracks.

5) helper autoload won't work from packet path.
   I'd propose to work around this by allowing periodic 'modprobes' from
   a work queue.
   Alternatively we could offload this job to userspace (nft should be
   able to figure out the needed modules too).

6).

A consequence of such a design would be that this works:
nf .. ct zone set 42 ct timeout set bla

The first part, ct zone set 42, would set template to zone 42, and set
skb->nfct to a template

The second part would do a conntrack lookup with the zone provided by
the template call nf_conntrack_in(skb), with the zone provided, and assign
skb->nfct to the *real* conntrack, and set timeout policy to the one
provided.  Problem is that things won't work when order is switched, i.e.:

nf .. ct timeout set bla ct zone set 42

(first we do a conntrack lookup in default zone, then fail
 to set the zone because skb->nfct is already set to a non-templated
 conntrack).

In case noone reports obvious showstoppers I'd explore an implementation
of the above scheme since I believe the advantages outweight the problems.

Footnotes:

[1], yuck, this creates again a syntax problem with meta keyword, because
     "ctevents set 'mark|new' refers to the IPCT event named 'mark', not the meta mark
     keyword, but we can't represent this ... :-(
     We will probably have to use a different word, e.g. 'ctmark' instead here, or force
     users to use "" quotes...
