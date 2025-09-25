Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672A85C4A
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 00:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759372; cv=fail; b=TZzAtoMahh1/A0vlhSp0RlsUZgrkHu7Tsz/Z5yHnOAC6sfrK8hUVBL2Y+1hXY7DdI0nwmUaNeaVaqrMMqunnWIu4yTux1tpwwFtZPzPmBc1R0OLV2l1NpOIIxaqgU6TS3Rc4EkrUfwLgeFmB3QINCwJSY+Was2/3/ahzDmHxn2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759372; c=relaxed/simple;
	bh=9FV9Yqf5KnLNuLwADnS0GbhClyunML7d2rnLYW3ErlY=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=m1SgHWZXyVgMmz5igB5tt63l3V2/r7uvn57+z9qwua7GgT7bsfhhrs0F/CHJohABRh5cA8VtYVmSma5KYbQbt9GTjdSHXGHOXzbeIkqtODAAyU9po+nsoN4RM3bYaHoDpTpuZvS8Yz74EcMh2vQPmTn6SkOSOW+G78C/mqKg1qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=fail smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EA81E501CE4;
	Thu, 25 Sep 2025 00:07:59 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-8.trex.outbound.svc.cluster.local [100.110.251.83])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 17835501CA8
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 00:07:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758758879; a=rsa-sha256;
	cv=none;
	b=Cf2HHIq5vV0EYYurjs4IjwGpv4JU5LFJnuS/8I3WLVuEJrYRbYKwExcApklKryAdSMSxDb
	6WZ8yQrWVTPJURZ6l5xCLw9KJv8iyC0jfZk0fvn4u9AVTMaOzHpNMGaQeGqSZikcC+YxK8
	/x/mKNWhb2hH7gCMhFeoYn1xNC4FinC36QGMRomC72hQiTO1esX2W7zLTDehkxAVygOBu0
	gwAqhI6X/QrTcvF87uQd/JPpt+MBJZt5rENaD5Zir3yee6wNi0zHMWIY1i8RVYDDzSCZIb
	NEeBxMSp124/VRP57AcO29xHDzbWzjBpZpCbMeUFL1izsuVHma2ZjFi8I0GqjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758758879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=32RSrjcmX9DIssXv/sFFXkMIiPs/fpF68xULbL9BCaU=;
	b=XgBVUVE/zBe4pjtDviZymbgnmzs3mnf7D9b0jNT/oMi5ZjR3rtgACLrkrKIDd+0Klx+0WO
	oR78N2UOx5phcNr/WwuEFj9r0qy85BWs2fzSq32lPL+wx09/BmxN64rH5NOFjIe4SmXizT
	Z4Lmu14/1VzOcuyt3XBvGA7VBldlGpkf2Y+YBjvm23vgZgg7k1jgpu2onpqLDLqBqVlu2P
	h1CeM9KgntbHqTYeZ9X1bYmjPX6zalKQU5bkuXLxIkZODrqnQzWc0PDqtN+Czl7Cgi6Zwi
	5SmgSuaqpt4w9dahkkZriDElBYvmOA1jHDX3qBVt6OAmvsAdfJ0Z9CpZnBxSow==
ARC-Authentication-Results: i=1;
	rspamd-b66946488-z775w;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Robust-Bubble: 669be8e00494321c_1758758879829_1658661267
X-MC-Loop-Signature: 1758758879829:3384916752
X-MC-Ingress-Time: 1758758879829
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.251.83 (trex/7.1.3);
	Thu, 25 Sep 2025 00:07:59 +0000
Received: from [79.127.207.171] (port=22569 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1ZWh-000000051DU-0pd6
	for netfilter-devel@vger.kernel.org;
	Thu, 25 Sep 2025 00:07:57 +0000
Message-ID: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
Subject: nft manpage/wiki issues and improvement ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: netfilter-devel@vger.kernel.org
Date: Thu, 25 Sep 2025 02:07:56 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.


I recently started migrating all my iptables config to nftables (better
late than never :-P)... and along reading through all the nftables.org
wiki pages and most of the manpage I've noticed all kinds of
documentation issues or things that might be improved...

But since I'm all but an expert (I merely have to do my netfilter
config at some university science cluster), I'm not really sure whether
I could give definite answers, so... a far too long O:-) list of things
that could be visited by some expert.


1) Non-documentation issue, could however be a downstream bug:
      # nft describe icmpv6 code
      payload expression, datatype icmpv6_code (icmpv6 code) (basetype inte=
ger), 8 bits
      # nft describe icmp code
      payload expression, datatype icmp_code (icmp code) (basetype integer)=
, 8 bits
  =20
   produce no (code) output as of at least v1.1.5.
   That still worked in older versions.


In the manpage:


2) Section CHAINS
  =20
>    The priority parameter accepts a signed integer value or a standard
>    priority name which specifies the order in which chains with the same
>    hook value are traversed.
  =20
   IMO it would be helpful if something like "the same hook REGARDLESS OF
   THEIR TABLE" would be added.
   Maybe even elaborating a bit more that tables, AFAIU, aren't really
   seen by netfilter at all and have no impact on any processing.

>    The ordering is ascending, i.e. lower priority values have precedence
>    over higher ones.
     =20
   A bit ambiguous, IMO it would be better to say "chains with lower
   priority values are processed first".
   "Precedence" could be easily interpreted as "the verdict of such chains
   winning", but AFAIU that's only the case if the verdict is drop, not if
   accept.


3) Section VERDICT STATEMENT
>    accept and drop are absolute verdicts =E2=80=94 they terminate ruleset
>    evaluation immediately.
  =20
   and
  =20
> accept
> Terminate ruleset evaluation and accept the packet. The packet can
> still be dropped later by another hook, for instance accept in the
> forward hook still allows one to drop the packet later in the
> postrouting hook, or another forward base chain that has a higher
> priority number and is evaluated afterwards in the processing
> pipeline.
  =20
   Seem contradicting and misleading.
  =20
   "ruleset" is previously used as the whole set of all rules in all
   chains + all set definitions.
   The first paragraph says they'd end all evaluation of that immediately.
   The 2nd says... no no.. other hooks can still change.
  =20
   What I think the first paragraph wants to say is:
  =20
   accept and deny terminate *even* the evaluation of the rule like in:
       ip daddr 1.1.1.1 drop counter
   counter wouldn't be executed (though many examples seem to use
   comment after the verdict... not sure about that).
  =20
   It also doesn't explain whether reject is also behaving like drop wrt
   evaluation (so one must assume at that point: no), like in:
       ip daddr 1.1.1.1 reject counter
  =20
  =20
   And with respect to how chain processing is affected by the verdicts
   (AFAIU):
   - drop, regardless in which chain, as soon as it is encountered will
     truly drop the packet.
     No later chain (be it at the same hook with a higher priority, or
     at another hook) can change that.
     There is also no returning from regular chains back to their callers.
   - accept, merely accepts the packet with respect to the current
     call stack of chains.
     Another base chain (or regular called from that) at the same hook
     but of higher priority OR at another hook could still
     drop(/reject?) (but not accept) it.
  =20
   The 2nd paragraph rather confusingly (why mentioning the forward
   hook?!) explains the one case... but that even a chain of the SAME hook
   but with higher priority could still turn the accept to drop... is only
   with much phantasy in that text.
  =20
   - Again, no word about whether reject works here like drop.
     I think it does, i.e. the reject of a chain would override another
     chain's allow

   The description of drop does a better job.

> jump CHAIN
> Continue evaluation at the first rule in CHAIN. The current position
> in the ruleset is pushed to a call stack and evaluation will continue
> there when the new chain is entirely evaluated or a return verdict is
> issued. In case an absolute verdict is issued by a rule in the chain,
> ruleset evaluation terminates immediately and the specific action is
> taken.
  =20
   I don't think it makes sense for documentation to tell about pushing to
   call stack.
   A mere: at the end of the chain, or if a return verdict is found,
   processing resumes right after the rule which caused the jump.
   ?
  =20
   Again the wording that an absolute verdict terminates the (whole)
   ruleset evaluation is IMO misleading. Only a a drop(/reject?) would do
   so. An accept however would only end the evaluation of the call stack
   of chains from the current base chain.
   Not that of other base chains at the same hook with higher prio, or
   that of other hooks.
  =20
> goto CHAIN
> Similar to jump, but the current position is not pushed to the call
> stack, meaning that after the new chain evaluation will continue at
> the last chain instead of the one containing the goto statement.
        =20
   Maybe I misunderstood something, but that seems wrong.
  =20
   AFAIU
   (https://wiki.nftables.org/wiki-nftables/index.php/Jumping_to_chain see
   jump vs goto), goto does *not* return, but simply uses the policy of
   the base chain (not of the regular chain, which has no policy).


4) Neither the wiki nor the manpage seems to have a section which
   briefly describes how tables/chains/rules are actually processed.
   It's all rather widely dispersed over many pages/sections and
   difficult to grasp, especially since some documentation seems plain
   wrong and misleading.

AFAIU it works as follows:

- technically (in the sense how the actual evaluation is done) tables
  don't matter at all
- packets traverse the network stack and at various hooks they're
  evaluated by the chains attached to that hook
  and even after netfilter they might still get reject (e.g. by things
  like rp_filter, or when icmp.c simply discards certain ICMP types
- a drop/reject verdict (including a drop that results from chain
  policy) actually drops the package and stops any further evaluation
  of:
  - the current chains
    if a regular, also the ones up to the base chain that called it
  - of other chains (in particular of higher priority) at the same hook
    (regardless of their table)
  - of other chains (of any priority) at other (in particular: later)
    hooks
    (regardless of their table)
  =3D> Thus if any base-chain uses drop as policy, this chain must either
     accept the package, or it will be (overall) dropped (as other base
    chains cannot override the drop from the policy of that chain).
- an accept verdict (including an accept that results from chain
  policy) *only* accepts the package from the current chain's point of
  view (that is: the current regular chain up to the base chain from
  which it was called or, if no regular chain, the current base chain).
  - chains (regardless from which table) of higher priority at the same
    hook as well as
  - chains (of any priority and regardless from which table) of later
    hooks
  all may still deny/reject the package, in which case it would be
  dropped/rejected as described above at drop/reject verdict
  =3D> Thus a package is only actually accepted (from netfilter's PoV),
    =C2=A0if=C2=A0 none of the chains (regardless of their table) from all =
of the
     relevant hooks does anything other than accept (be it via verdict,
     policy or implicit policy default).
  =3D> Thus the ordering of different call stacks of base chains via
     priorities, doesn't change whether a packet gets
     dropped/rejected/accepted, *unless* the package is modified or
     things like marks are set, which would change the matching of
     rules in other chains
- any terminating verdict (drop/reject/accept...TODO: also goto/jump?)
  also end evaluation of the current rule, that is:
     ip daddr 1.1.1.1 accept counter
  causes counter to be ignored other than in:
     ip daddr 1.1.1.1 counter accept
  TODO: also the case with comment?
- jump C
  - continues evaluation at the first rule of C
  - a accept/drop/reject verdict in C via rule causes evaluation of
the=C2=A0   call stack of chains to end and thus there will be no implicit
    return to the calling chain
  - a return verdict in C, causes to continue the evaluation in the
    calling chain after the rule that caused the jump
  - reaching the end of rules in C, causes an implicit return
- goto C
  - continues evaluation at the first rule of C
  - a accept/drop/reject verdict in C via rule causes evaluation of the
    call stack of chains to end and thus there will be no implicit
    return to the calling chain
  - reaching the end of rules in C, causes the policy of the original
    base chain to be used.
  TODO: What I haven't checked now, but also seems not documented:
      - Can one use return in a chain to which one got via goto and if
        so, what happens?
      - Can on jump/goto to other base chains?
        And if so, which the policy of which base-chain would be used
        when reaching the end of a regular chain one entered via goto?


5) Quite some syntax seems completely undocumented... e.g. what
   operators one can use with tcp_flag and what "," means with
   bitfields like in ct state.
   Also the syntax introduced in
   https://git.netfilter.org/nftables/commit/?id=3Dc3d57114f119b89ec0caa0b4=
dfa8527826a38792


6) It doesn't seem to be documented how exactly the sorting is done
   when including files (which may be quite important).
   As far as I could see in the code, the wildcards are done via glob()
   an since setlocale() doesn't seem to be handled throughout the code,
   it seems to be the collation order of the C locale (which would of
   course break, should localisation ever be added).


In the Wiki:


7) https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains
> NOTE: If a packet is accepted and there is another chain, bearing the
> same hook type and with a later priority, then the packet will
> subsequently traverse this other chain. Hence, an accept verdict - be
> it by way of a rule or the default chain policy - isn't necessarily
> final. However, the same is not true of packets that are subjected to
> a drop verdict. Instead, drops take immediate effect, with no further
> rules or chains being evaluated.=20
  =20
   Looks mostly right to me, but misses the point that chains of other
   later hooks can also still drop/reject the package.
   Also, misses whether or not rejects are like drops here.
  =20
>    In summary, packets will traverse all of the chains within the scope
>    of a given hook until they are either dropped or no more base chains
>    exist. An accept verdict is only guaranteed to be final in the case
>    that there is no later chain bearing the same type of hook as the
>    chain that the packet originally entered.
  =20
   In principle right, but misses the point that a later hook (and its
   chains) may still drop/reject the package.


8) https://wiki.nftables.org/wiki-nftables/index.php/Sets
   Claims that the max length of set names is 16... but I created way
   longer ones (which seemed to work... and it's really good to be able to
   :-) ).

   Also in there is chapter 2.1, which is part of chapter 2 named sets.
   Not sure why 2.1 is in there, because its main new information is $VAR,
   which is however, AFAIU, not a set.
   In particular, what the example uses with:
>    tcp dport { http, https } ip saddr $CDN accept

   is an anonymous set, not a named one (and we're still in the chapter of
   named ones).


   The really interesting thing, namely "sets referencing other sets" like
   in:
>    define CDN =3D {
>        $CDN_EDGE,
>        $CDN_MONITORS
>    }

   I may be wrong, but these seem to be rather mere string operations
   ultimately causing an anonymous set, right? One can e.g. also do:
>    elements=3D{{{1.1.1.1, 1.1.2.2}, 2.2.2.2}, 3.3.3.3 }
   and it will simply remove any inner { }.
   I think this should somehow be mentioned, so that people don't think
   they could do dynamic things like { @setA, @setB}
  =20
  =20
9) Perhaps more a question to be sure:
>    A hash sign (#) begins a comment. All following characters on the
>    same line are ignored.
   Is that really meant to imply that end-of-line comments work, i.e.
   > ip dport 1.1.1.1 accept #foo bar baz
   is supported?
  =20
   I merely ask cause I've seen config parsers (I think it was either
   ssh_config or sshd_confg) which did work with end of line comments but
   were never intended to and it was ultimately removed.
  =20

10) https://wiki.nftables.org/wiki-nftables/index.php/Atomic_rule_replaceme=
nt
   - Missing from the manpage.
   - What should IMO also be mentioned is, that if the new ruleset
     contains errors, than despite the ruleset flush, the old rules
     stay in place unmodified... which is quite important.

> What happens when you include 2 files which each have a statement for
> the filter table? If you have two included files both with statements
> for the filter table, but one adds a rule allowing traffic from
> 192.168.1.1 and the other allows traffic from 192.168.1.2 then both
> rules will be included in the chain, even if one or both files
> contains a flush statement.
     =20
      and
     =20
> What about flush statements in either, or neither file? If there are
> any flush commands in any included file then those will be run at the
> moment the config swap is executed, not at the moment the file is
> loaded. If you do not include a flush statement in any included file,
> you will get duplicate rules. If you do include a flush statement,
> you will not get duplicate rules and the config from *both* files
> will be included.
     =20
   Maybe I got something wrong, but this reads as if flush statements in
   the two different files were effectively handled like one.
  =20
   I tried a bit, and that doesn't seem to be the case. It rather seems as
   if flush statements would be as if they were processed when encountered
   during parsing.
   E.g.
   main.nft:
      #!/usr/sbin/nft -f
      flush ruleset
      table inet filter {
              chain input {
                      type filter hook input priority filter
                      iifname lo accept
              }
      }
      include "included.nft"
  =20
  =20
   included.nft:
      #flush ruleset
      table inet filter {=20
              chain bla {
                      type filter hook input priority filter
                      ip daddr 1.1.1.1 drop
              }
      }
  =20
   If I load it like this, I get both chains.
   If however I uncomment the flash in included.nft, I only get the bla
   chain, i.e. input must have been flushed away.


Generally missing (to my best knowledge):

11) ct state {a,b} vs. ct state a,b
    or better said: what "," does in bitfields
    based on Florian Westphal's answer[0] I'd assume that "," in
    bitfields cause the statement to match, if any (or all) of the
    named bits are set.

    Also, from his explanation ct state {a,b} matches only if either a
    (but not b) or b (but not a) is set.
    Not sure about this, but I read the whole wiki and all generic
    parts of the manpage, and I don't think it was ever mentioned that
    matching sets work like this.
    I mean it probably doesn't make a difference for things like
    addresses, port ranges or ICMP types, where one can anyway only
    have always one value,... but for things like bitfiedls it might.


12) is <predicate> <value> generally the same as <predicate> eq <value>
    Like in:
    dport 22
    dport eq 22


13) "Teaching"
    Well, obviously one can't explain everything, but I think for some
    very common uses cases, it would be nice to give advise to users,
    e.g.:
    - If matching the loopback iface, iif, oif should always fine and
      be faster (assuming the ID of lo is guaranteed to be always 1).
      I tried to create further loopbacks or remove it, but that
      generally seems to no longer work.
      Would it be somehow possibly... and would iiftype oiftype be as
     =C2=A0fast as checking the number... then maybe one should suggest
      that?

      At the same time, telling people this isn't safe for their
      eth0/wlan0.
      Yes, there is some note about this in the manpage:
>       This is because internally the interface index is used. In case of
>       dynamically created interfaces, such as tun/tap or dialup interface=
s
>       (ppp for example), it might be better to use iifname or oifnam
>       instead.
      But I wouldn't be surprised if may people are not experienced with
      these types of ifaces, and might simply assume their eth/wlan is fine=
.
     =20
      At least I found many wikis, blogs, which do use iif/oif for eth/wlan=
.
     =20
   - Telling that:
        ct state established,related accept
     (who doesn't have such a rule ;-) )
     is probably a bit faster than:
        ct state {established,related} accept

   Giving some performance guidelines:

   - E.g. I blindly assume that the conntrack state of the packet is
     already available and thus a check like ct state new is super
     fast, and in particular faster than doing
        tcp flags & (syn|ack|fin|rst) =3D=3D syn
     which in turn may or may not (I don't know) be slower than
        tcp flags syn / syn,ack,fin,rst
     of which there are countless examples to match "new" TCP
     connections.

   - What I quite often see is that people have some base rules and
     then simple port based matches or TCP, UDP... often with a check
     whether the connection is new.
     So one get's lists of:
        ct state new tcp dport ...
        ct state new tcp dport ...
        ct state new tcp dport ...
     Even assuming ct state is fast... (when) would it be better to do e.g.=
:
        ct state new jump new_queue
     and only in new_queue do the tcp dport, udp dport rules?

   - Does it performance wise make any difference to do e.g.
       ct state new tcp dport 22
     or
       tcp dport 22 ct state new
     respectively some guidelines *which* matching expressions are
     super fast and which are rather slow?

   - Assume e.g. the above case, where one has *many*:
        tcp dport ... <do this>
        tcp dport ... <do that>
        udp dport ... <do this>
        udp dport ... <do that>
     What one could obviously do is.
        meta l4proto tcp jump tcp_conns
        meta l4proto udp jump udp_conns
     and handle the port matching in these regular chains.

     But this gives one basically:
     - one extra expression that checks the type (which tcp/udp
       statements would anyway already do
     - the costs of the jump (and return)

     The question is again: When is it worth it?
    =20

Thanks and best wishes,
Chris.


[0] https://lore.kernel.org/netfilter/aNPhP63SyX2ofE92@strlen.de/T/#m15841d=
b7bf5bb588483fdd3576d70af7a71f5555
