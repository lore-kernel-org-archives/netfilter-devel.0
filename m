From: "James King" <t.james.king@gmail.com>
Subject: Re: POM Xtables???
Date: Fri, 15 Aug 2008 01:17:41 -0700
Message-ID: <38bcb3ec0808150117n729cb7b1yadcfa9018b9714be@mail.gmail.com>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>
	 <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com>
	 <486907EA.60105@trash.net>
	 <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr>
	 <48694787.3080906@trash.net>
	 <alpine.LNX.1.10.0807010907040.26892@fbirervta.pbzchgretzou.qr>
	 <4887BCE0.2050902@trash.net>
	 <38bcb3ec0807240131n1f5d4051k9e89731aa2fcb6c9@mail.gmail.com>
	 <488849A5.6050401@netfilter.org> <48884ED3.8080901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Jan Engelhardt" <jengelh@medozas.de>, Dave <finalglide@gmail.com>,
	netfilter@vger.kernel.org,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:19213 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYHOIRl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:17:41 -0400
Received: by rv-out-0506.google.com with SMTP id k40so838023rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2008 01:17:41 -0700 (PDT)
In-Reply-To: <48884ED3.8080901@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(Sorry for the spam Patrick, I just realized that I didn't reply-all
the first time around)

On Thu, Jul 24, 2008 at 2:43 AM, Patrick McHardy <kaber@trash.net> wrote:
>> James King wrote:
>>> One thing
>>> I'm not sure of is whether the license used by the Henry Spencer regex
>>> library it depends on is acceptable by kernel standards (or whether
>>> it's permissive enough to relicense under GPL, as IANAL).
>
> I know of the regexp.old.zip library, which IIRC used a GPL
> compatible license (and a non-POSIX conform interface).
>
>> If we want to do this in-kernel I think that it's better if it must use
>> the textsearch infrastructure. Probably it would require some patches to
>> extend the existing infrastructure.
>
> I'd also prefer that over adding a regex library to the kernel.
> I think one of the bigger problems is that there are dependencies
> in the match that can't be easily expressed, like "byte 4 has
> skb->len - 10". At least ipp2p does something like that. But
> maybe thats not necessary, since l7filter already uses regexes
> there's apparently a different method for doing this.
>
> It would be useful if someone could post an excerpt from the
> l7filter expressions or simply the entire patch.

ipp2p and l7filter both use different strategies for DPI
classification, each having their own pros and cons.

ipp2p has the potential to classify traffic faster since it uses magic
values/offsets before moving on to more detailed searches.  As you
noted above, the match can also be a bit "deeper" since it can express
more complex relationships.  It's also better for memory usage, since
it doesn't store packet data.  The downside is poor configurability
and maintainability.

l7filter adds a buffer (default size of 2048 bytes, kmalloc'd on the
first packet of a flow, and freed after classification is complete) to
the conntrack and appends inbound and outbound packets into this
buffer (in the order received), up to a configurable number of packets
before giving up on classification.  It runs each configured regex
rule against this buffer in sequence, which can get very expensive
especially when you have a lot of matches or your patterns include a
lot of branches, since a large amount of search work is potentially
being duplicated by each rule.  However, being able to setup these
matches at runtime is what makes l7filter much more convenient to use
overall.

After reviewing the l7filter code a bit, I've found that it does some
nasty things at present like holding a BH spinlock over the entire
match function, and allocating a per-conntrack character buffer
containing the string name of the pattern that we've matched (eg.
http-audio, bittorrent, battlefield2, etc) for the entire life of the
conntrack.  Also, the work necessary to convert the backend to use
textsearch and still maintain compatibility with the existing patterns
seems a bit prohibitive at the moment.

I think the best thing to do for now is to move it into xtables-addons
(providing Jan has no objections) for further review and cleanup.
I've had a bit of time to work on this during my vacation, but I was
wondering if I could get some clarification on a couple things:
-Under what circumstances does it become mandatory to implement the
ct_extend move callback?
-The description from Krzystof's recent accounting patch (which btw
doesn't appear to have been merged during the last window after all)
notes:

"...newly created connections get additional acct extend.  Old
connections are not changed as it is not possible to add a ct_extend
area to confirmed conntrack"

His patch adds a call to nf_conntrack_acct_init() inside of
conntrack_init() to add the private area.  For an out of tree module,
obviously this isn't a good solution (I'd like to use this module
against a stock kernel if possible).  I suppose I could include
something like this near the beginning of the match function:

layer7 = nf_ct_ext_find(ct, NF_CT_EXT_LAYER7);
if (!layer7 && !nf_ct_is_confirmed(ct))
	ret = nf_ct_ext_add(ct, NF_CT_EXT_LAYER7, GFP_ATOMIC);

...but this seems kludgy.  Is there a better way of doing this?  If
not, maybe we could add an init callback to ct_extend (and basically
clone nf_ct_ext_destroy() and __nf_ct_ext_destroy()), and call it from
conntrack_init(), so any number of extensions can be added without
having to patch conntrack_init() each time.

-In the same thread of avoiding a kernel recompile, it would be great
if there was a way to add a new extension type on the fly, or at least
had one enumeration reserved for use by out of tree modules (eg.
NF_CT_EXT_RESERVED).  Any thoughts here?
