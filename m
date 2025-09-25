Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B57820E6
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 07:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758785724; cv=none; b=ka6GQ9rNDUJ+Zi9ZbE0T3pc9hvMAsYop3OjJMIJOugJT8foO08Yt6kQxYOts0YlJc0nph6HzmRA1myjWXxr3ZxrmSBDGUDAcQa0A6Pr9pFIFLEbBTzN/39lksGBCUc5o+vDb+rYqn/y7q6kAhW2Y4SsL7ZFuR54y9ofe2JRtggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758785724; c=relaxed/simple;
	bh=cNNSntK9J74Y6KzkQ2zcrI1Z9AOFr6xe4s24K2GeDMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUeq82QPN7EVHJ1G+IZOBYrs3FdPhlrC2EfuUbxTuDpiRlz4H2m1ZVzzRNxa+q9tfL7q4KEbmHKTYTxxiZl9wazS08W3iGr/tEj73NMu8/0sHDBufF1H/6ZsCpksRMRN9qHnuYOnJze7l7lCVQu4PHQ8GBxFSQFhDIo2Q9unkmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rgZU7WUP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jRqEhwqU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rgZU7WUP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jRqEhwqU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D166C60253; Thu, 25 Sep 2025 09:35:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758785717;
	bh=S3RpnTp0sLT3QvSBQE/ZhVHL9XdYlAJj9XB0IVJdFiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rgZU7WUPBRoQ9+wNV/fJlA8FEgtXS/1upudtScm/+QUK8PPQjwLQ5rm/OEpRSfBOe
	 2Cuw4EWsCZ5i2TEIct+Cn/D2CKDE5wVQDY0j4ZeiJzmXME/MVYrig57Zt2U7pMtgfM
	 wAHTJT3I3I3hkwJp/gaE2aJf6k9c4c/QhuDLb9wHOerFLM6GKXWxclWqZLTZHiepI3
	 hpc37BdLFhW7J6MbvM4QLPxRDsYpEiYTUm5+jARbZmNtZp7Q8YX94NZiBBG0ZM/uxS
	 NNz7UQl5MQxTdbHl6Uf4OodkGgn9OIGgHPwc46LPJ00fFndGLYPnBYxu4oHeRksR52
	 R4tKT2pMGPsbQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D44760253;
	Thu, 25 Sep 2025 09:35:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758785715;
	bh=S3RpnTp0sLT3QvSBQE/ZhVHL9XdYlAJj9XB0IVJdFiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jRqEhwqU1MjelEodW1jImzLSctnTOCx1Ay+lFBrRQCJsqc1sCYRB+MfnWBWh1KxAR
	 cs4AN+411EJS8vtoxzY1Yorsr5WQ52lIL+6pJRa9jDY9Li37JPBUvXnL84qfJqh5+h
	 zHRl6Cx4O0VbC40Y7O8LPbUuh7KEn6nIS9kfRie6qRklH++AjqeW0ejR0V3vgCsxpu
	 3AKqhj9UH+3fne30Ku+oYg0UH+/NGqLHx4d5rwKPlNMCcDKERMDbX10PdzfA9cREQv
	 x1I0Qa9PV2x31jFOBwuZkc1y+eCr+utwaftPnT7l+P5MPmQgaRwwXAdCRuOXqFyx+q
	 CShKmYdXH8fdw==
Date: Thu, 25 Sep 2025 09:35:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nft manpage/wiki issues and improvement ideas
Message-ID: <aNTwsMd8wSe4aKmz@calendula>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>

On Thu, Sep 25, 2025 at 02:07:56AM +0200, Christoph Anton Mitterer wrote:
> Hey.
> 
> 
> I recently started migrating all my iptables config to nftables (better
> late than never :-P)... and along reading through all the nftables.org
> wiki pages and most of the manpage I've noticed all kinds of
> documentation issues or things that might be improved...
> 
> But since I'm all but an expert (I merely have to do my netfilter
> config at some university science cluster), I'm not really sure whether
> I could give definite answers, so... a far too long O:-) list of things
> that could be visited by some expert.
> 
> 
> 1) Non-documentation issue, could however be a downstream bug:
>       # nft describe icmpv6 code
>       payload expression, datatype icmpv6_code (icmpv6 code) (basetype integer), 8 bits
>       # nft describe icmp code
>       payload expression, datatype icmp_code (icmp code) (basetype integer), 8 bits
>    
>    produce no (code) output as of at least v1.1.5.
>    That still worked in older versions.

What do you mean by no output?

# nft -v
nftables v1.1.5 (Commodore Bullmoose #6)
# nft describe icmp code
payload expression, datatype icmp_code (icmp code) (basetype integer), 8 bits
# nft describe icmpv6 code
payload expression, datatype icmpv6_code (icmpv6 code) (basetype integer), 8 bits

As for your lengthy notes, it is easier for us if you send us
individual patches for each issue that can be reviewed.

This is more work on your side, but less work on us to digest this
lengthy notes.

Thanks.

> In the manpage:
> 
> 
> 2) Section CHAINS
>    
> >    The priority parameter accepts a signed integer value or a standard
> >    priority name which specifies the order in which chains with the same
> >    hook value are traversed.
>    
>    IMO it would be helpful if something like "the same hook REGARDLESS OF
>    THEIR TABLE" would be added.
>    Maybe even elaborating a bit more that tables, AFAIU, aren't really
>    seen by netfilter at all and have no impact on any processing.
> 
> >    The ordering is ascending, i.e. lower priority values have precedence
> >    over higher ones.
>       
>    A bit ambiguous, IMO it would be better to say "chains with lower
>    priority values are processed first".
>    "Precedence" could be easily interpreted as "the verdict of such chains
>    winning", but AFAIU that's only the case if the verdict is drop, not if
>    accept.
> 
> 
> 3) Section VERDICT STATEMENT
> >    accept and drop are absolute verdicts — they terminate ruleset
> >    evaluation immediately.
>    
>    and
>    
> > accept
> > Terminate ruleset evaluation and accept the packet. The packet can
> > still be dropped later by another hook, for instance accept in the
> > forward hook still allows one to drop the packet later in the
> > postrouting hook, or another forward base chain that has a higher
> > priority number and is evaluated afterwards in the processing
> > pipeline.
>    
>    Seem contradicting and misleading.
>    
>    "ruleset" is previously used as the whole set of all rules in all
>    chains + all set definitions.
>    The first paragraph says they'd end all evaluation of that immediately.
>    The 2nd says... no no.. other hooks can still change.
>    
>    What I think the first paragraph wants to say is:
>    
>    accept and deny terminate *even* the evaluation of the rule like in:
>        ip daddr 1.1.1.1 drop counter
>    counter wouldn't be executed (though many examples seem to use
>    comment after the verdict... not sure about that).
>    
>    It also doesn't explain whether reject is also behaving like drop wrt
>    evaluation (so one must assume at that point: no), like in:
>        ip daddr 1.1.1.1 reject counter
>    
>    
>    And with respect to how chain processing is affected by the verdicts
>    (AFAIU):
>    - drop, regardless in which chain, as soon as it is encountered will
>      truly drop the packet.
>      No later chain (be it at the same hook with a higher priority, or
>      at another hook) can change that.
>      There is also no returning from regular chains back to their callers.
>    - accept, merely accepts the packet with respect to the current
>      call stack of chains.
>      Another base chain (or regular called from that) at the same hook
>      but of higher priority OR at another hook could still
>      drop(/reject?) (but not accept) it.
>    
>    The 2nd paragraph rather confusingly (why mentioning the forward
>    hook?!) explains the one case... but that even a chain of the SAME hook
>    but with higher priority could still turn the accept to drop... is only
>    with much phantasy in that text.
>    
>    - Again, no word about whether reject works here like drop.
>      I think it does, i.e. the reject of a chain would override another
>      chain's allow
> 
>    The description of drop does a better job.
> 
> > jump CHAIN
> > Continue evaluation at the first rule in CHAIN. The current position
> > in the ruleset is pushed to a call stack and evaluation will continue
> > there when the new chain is entirely evaluated or a return verdict is
> > issued. In case an absolute verdict is issued by a rule in the chain,
> > ruleset evaluation terminates immediately and the specific action is
> > taken.
>    
>    I don't think it makes sense for documentation to tell about pushing to
>    call stack.
>    A mere: at the end of the chain, or if a return verdict is found,
>    processing resumes right after the rule which caused the jump.
>    ?
>    
>    Again the wording that an absolute verdict terminates the (whole)
>    ruleset evaluation is IMO misleading. Only a a drop(/reject?) would do
>    so. An accept however would only end the evaluation of the call stack
>    of chains from the current base chain.
>    Not that of other base chains at the same hook with higher prio, or
>    that of other hooks.
>    
> > goto CHAIN
> > Similar to jump, but the current position is not pushed to the call
> > stack, meaning that after the new chain evaluation will continue at
> > the last chain instead of the one containing the goto statement.
>          
>    Maybe I misunderstood something, but that seems wrong.
>    
>    AFAIU
>    (https://wiki.nftables.org/wiki-nftables/index.php/Jumping_to_chain see
>    jump vs goto), goto does *not* return, but simply uses the policy of
>    the base chain (not of the regular chain, which has no policy).
>
> 4) Neither the wiki nor the manpage seems to have a section which
>    briefly describes how tables/chains/rules are actually processed.
>    It's all rather widely dispersed over many pages/sections and
>    difficult to grasp, especially since some documentation seems plain
>    wrong and misleading.
> 
> AFAIU it works as follows:
> 
> - technically (in the sense how the actual evaluation is done) tables
>   don't matter at all
> - packets traverse the network stack and at various hooks they're
>   evaluated by the chains attached to that hook
>   and even after netfilter they might still get reject (e.g. by things
>   like rp_filter, or when icmp.c simply discards certain ICMP types
> - a drop/reject verdict (including a drop that results from chain
>   policy) actually drops the package and stops any further evaluation
>   of:
>   - the current chains
>     if a regular, also the ones up to the base chain that called it
>   - of other chains (in particular of higher priority) at the same hook
>     (regardless of their table)
>   - of other chains (of any priority) at other (in particular: later)
>     hooks
>     (regardless of their table)
>   => Thus if any base-chain uses drop as policy, this chain must either
>      accept the package, or it will be (overall) dropped (as other base
>     chains cannot override the drop from the policy of that chain).
> - an accept verdict (including an accept that results from chain
>   policy) *only* accepts the package from the current chain's point of
>   view (that is: the current regular chain up to the base chain from
>   which it was called or, if no regular chain, the current base chain).
>   - chains (regardless from which table) of higher priority at the same
>     hook as well as
>   - chains (of any priority and regardless from which table) of later
>     hooks
>   all may still deny/reject the package, in which case it would be
>   dropped/rejected as described above at drop/reject verdict
>   => Thus a package is only actually accepted (from netfilter's PoV),
>      if  none of the chains (regardless of their table) from all of the
>      relevant hooks does anything other than accept (be it via verdict,
>      policy or implicit policy default).
>   => Thus the ordering of different call stacks of base chains via
>      priorities, doesn't change whether a packet gets
>      dropped/rejected/accepted, *unless* the package is modified or
>      things like marks are set, which would change the matching of
>      rules in other chains
> - any terminating verdict (drop/reject/accept...TODO: also goto/jump?)
>   also end evaluation of the current rule, that is:
>      ip daddr 1.1.1.1 accept counter
>   causes counter to be ignored other than in:
>      ip daddr 1.1.1.1 counter accept
>   TODO: also the case with comment?
> - jump C
>   - continues evaluation at the first rule of C
>   - a accept/drop/reject verdict in C via rule causes evaluation of
> the    call stack of chains to end and thus there will be no implicit
>     return to the calling chain
>   - a return verdict in C, causes to continue the evaluation in the
>     calling chain after the rule that caused the jump
>   - reaching the end of rules in C, causes an implicit return
> - goto C
>   - continues evaluation at the first rule of C
>   - a accept/drop/reject verdict in C via rule causes evaluation of the
>     call stack of chains to end and thus there will be no implicit
>     return to the calling chain
>   - reaching the end of rules in C, causes the policy of the original
>     base chain to be used.
>   TODO: What I haven't checked now, but also seems not documented:
>       - Can one use return in a chain to which one got via goto and if
>         so, what happens?
>       - Can on jump/goto to other base chains?
>         And if so, which the policy of which base-chain would be used
>         when reaching the end of a regular chain one entered via goto?
> 
> 
> 5) Quite some syntax seems completely undocumented... e.g. what
>    operators one can use with tcp_flag and what "," means with
>    bitfields like in ct state.
>    Also the syntax introduced in
>    https://git.netfilter.org/nftables/commit/?id=c3d57114f119b89ec0caa0b4dfa8527826a38792
> 
> 
> 6) It doesn't seem to be documented how exactly the sorting is done
>    when including files (which may be quite important).
>    As far as I could see in the code, the wildcards are done via glob()
>    an since setlocale() doesn't seem to be handled throughout the code,
>    it seems to be the collation order of the C locale (which would of
>    course break, should localisation ever be added).
> 
> 
> In the Wiki:
> 
> 
> 7) https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains
> > NOTE: If a packet is accepted and there is another chain, bearing the
> > same hook type and with a later priority, then the packet will
> > subsequently traverse this other chain. Hence, an accept verdict - be
> > it by way of a rule or the default chain policy - isn't necessarily
> > final. However, the same is not true of packets that are subjected to
> > a drop verdict. Instead, drops take immediate effect, with no further
> > rules or chains being evaluated. 
>    
>    Looks mostly right to me, but misses the point that chains of other
>    later hooks can also still drop/reject the package.
>    Also, misses whether or not rejects are like drops here.
>    
> >    In summary, packets will traverse all of the chains within the scope
> >    of a given hook until they are either dropped or no more base chains
> >    exist. An accept verdict is only guaranteed to be final in the case
> >    that there is no later chain bearing the same type of hook as the
> >    chain that the packet originally entered.
>    
>    In principle right, but misses the point that a later hook (and its
>    chains) may still drop/reject the package.
> 
> 
> 8) https://wiki.nftables.org/wiki-nftables/index.php/Sets
>    Claims that the max length of set names is 16... but I created way
>    longer ones (which seemed to work... and it's really good to be able to
>    :-) ).
> 
>    Also in there is chapter 2.1, which is part of chapter 2 named sets.
>    Not sure why 2.1 is in there, because its main new information is $VAR,
>    which is however, AFAIU, not a set.
>    In particular, what the example uses with:
> >    tcp dport { http, https } ip saddr $CDN accept
> 
>    is an anonymous set, not a named one (and we're still in the chapter of
>    named ones).
> 
> 
>    The really interesting thing, namely "sets referencing other sets" like
>    in:
> >    define CDN = {
> >        $CDN_EDGE,
> >        $CDN_MONITORS
> >    }
> 
>    I may be wrong, but these seem to be rather mere string operations
>    ultimately causing an anonymous set, right? One can e.g. also do:
> >    elements={{{1.1.1.1, 1.1.2.2}, 2.2.2.2}, 3.3.3.3 }
>    and it will simply remove any inner { }.
>    I think this should somehow be mentioned, so that people don't think
>    they could do dynamic things like { @setA, @setB}
>    
>    
> 9) Perhaps more a question to be sure:
> >    A hash sign (#) begins a comment. All following characters on the
> >    same line are ignored.
>    Is that really meant to imply that end-of-line comments work, i.e.
>    > ip dport 1.1.1.1 accept #foo bar baz
>    is supported?
>    
>    I merely ask cause I've seen config parsers (I think it was either
>    ssh_config or sshd_confg) which did work with end of line comments but
>    were never intended to and it was ultimately removed.
>    
> 
> 10) https://wiki.nftables.org/wiki-nftables/index.php/Atomic_rule_replacement
>    - Missing from the manpage.
>    - What should IMO also be mentioned is, that if the new ruleset
>      contains errors, than despite the ruleset flush, the old rules
>      stay in place unmodified... which is quite important.
> 
> > What happens when you include 2 files which each have a statement for
> > the filter table? If you have two included files both with statements
> > for the filter table, but one adds a rule allowing traffic from
> > 192.168.1.1 and the other allows traffic from 192.168.1.2 then both
> > rules will be included in the chain, even if one or both files
> > contains a flush statement.
>       
>       and
>       
> > What about flush statements in either, or neither file? If there are
> > any flush commands in any included file then those will be run at the
> > moment the config swap is executed, not at the moment the file is
> > loaded. If you do not include a flush statement in any included file,
> > you will get duplicate rules. If you do include a flush statement,
> > you will not get duplicate rules and the config from *both* files
> > will be included.
>       
>    Maybe I got something wrong, but this reads as if flush statements in
>    the two different files were effectively handled like one.
>    
>    I tried a bit, and that doesn't seem to be the case. It rather seems as
>    if flush statements would be as if they were processed when encountered
>    during parsing.
>    E.g.
>    main.nft:
>       #!/usr/sbin/nft -f
>       flush ruleset
>       table inet filter {
>               chain input {
>                       type filter hook input priority filter
>                       iifname lo accept
>               }
>       }
>       include "included.nft"
>    
>    
>    included.nft:
>       #flush ruleset
>       table inet filter { 
>               chain bla {
>                       type filter hook input priority filter
>                       ip daddr 1.1.1.1 drop
>               }
>       }
>    
>    If I load it like this, I get both chains.
>    If however I uncomment the flash in included.nft, I only get the bla
>    chain, i.e. input must have been flushed away.
> 
> 
> Generally missing (to my best knowledge):
> 
> 11) ct state {a,b} vs. ct state a,b
>     or better said: what "," does in bitfields
>     based on Florian Westphal's answer[0] I'd assume that "," in
>     bitfields cause the statement to match, if any (or all) of the
>     named bits are set.
> 
>     Also, from his explanation ct state {a,b} matches only if either a
>     (but not b) or b (but not a) is set.
>     Not sure about this, but I read the whole wiki and all generic
>     parts of the manpage, and I don't think it was ever mentioned that
>     matching sets work like this.
>     I mean it probably doesn't make a difference for things like
>     addresses, port ranges or ICMP types, where one can anyway only
>     have always one value,... but for things like bitfiedls it might.
> 
> 
> 12) is <predicate> <value> generally the same as <predicate> eq <value>
>     Like in:
>     dport 22
>     dport eq 22
> 
> 
> 13) "Teaching"
>     Well, obviously one can't explain everything, but I think for some
>     very common uses cases, it would be nice to give advise to users,
>     e.g.:
>     - If matching the loopback iface, iif, oif should always fine and
>       be faster (assuming the ID of lo is guaranteed to be always 1).
>       I tried to create further loopbacks or remove it, but that
>       generally seems to no longer work.
>       Would it be somehow possibly... and would iiftype oiftype be as
>       fast as checking the number... then maybe one should suggest
>       that?
> 
>       At the same time, telling people this isn't safe for their
>       eth0/wlan0.
>       Yes, there is some note about this in the manpage:
> >       This is because internally the interface index is used. In case of
> >       dynamically created interfaces, such as tun/tap or dialup interfaces
> >       (ppp for example), it might be better to use iifname or oifnam
> >       instead.
>       But I wouldn't be surprised if may people are not experienced with
>       these types of ifaces, and might simply assume their eth/wlan is fine.
>       
>       At least I found many wikis, blogs, which do use iif/oif for eth/wlan.
>       
>    - Telling that:
>         ct state established,related accept
>      (who doesn't have such a rule ;-) )
>      is probably a bit faster than:
>         ct state {established,related} accept
> 
>    Giving some performance guidelines:
> 
>    - E.g. I blindly assume that the conntrack state of the packet is
>      already available and thus a check like ct state new is super
>      fast, and in particular faster than doing
>         tcp flags & (syn|ack|fin|rst) == syn
>      which in turn may or may not (I don't know) be slower than
>         tcp flags syn / syn,ack,fin,rst
>      of which there are countless examples to match "new" TCP
>      connections.
> 
>    - What I quite often see is that people have some base rules and
>      then simple port based matches or TCP, UDP... often with a check
>      whether the connection is new.
>      So one get's lists of:
>         ct state new tcp dport ...
>         ct state new tcp dport ...
>         ct state new tcp dport ...
>      Even assuming ct state is fast... (when) would it be better to do e.g.:
>         ct state new jump new_queue
>      and only in new_queue do the tcp dport, udp dport rules?
> 
>    - Does it performance wise make any difference to do e.g.
>        ct state new tcp dport 22
>      or
>        tcp dport 22 ct state new
>      respectively some guidelines *which* matching expressions are
>      super fast and which are rather slow?
> 
>    - Assume e.g. the above case, where one has *many*:
>         tcp dport ... <do this>
>         tcp dport ... <do that>
>         udp dport ... <do this>
>         udp dport ... <do that>
>      What one could obviously do is.
>         meta l4proto tcp jump tcp_conns
>         meta l4proto udp jump udp_conns
>      and handle the port matching in these regular chains.
> 
>      But this gives one basically:
>      - one extra expression that checks the type (which tcp/udp
>        statements would anyway already do
>      - the costs of the jump (and return)
> 
>      The question is again: When is it worth it?
>      
> 
> Thanks and best wishes,
> Chris.
> 
> 
> [0] https://lore.kernel.org/netfilter/aNPhP63SyX2ofE92@strlen.de/T/#m15841db7bf5bb588483fdd3576d70af7a71f5555
> 
