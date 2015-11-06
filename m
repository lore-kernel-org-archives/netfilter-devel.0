From: Florian Westphal <fw@strlen.de>
Subject: How to send nf trace notifications to userspace?
Date: Sat, 7 Nov 2015 00:29:00 +0100
Message-ID: <20151106232900.GA24154@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50854 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbbKFX3C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 18:29:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZuqRI-0006dz-PG
	for netfilter-devel@vger.kernel.org; Sat, 07 Nov 2015 00:29:00 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$subject says most of it.

I started to resurrect the 'nft trace' patch set from

https://patchwork.ozlabs.org/patch/444772/

It works ok with couple of changes to nf_tables_core and nfnetlink
to propagate trace type (return, policy, ...) and the handle of the
rule currently processed.  Also saves us from the 'rule counting'
that we're currently doing in kernel.

$ src/nft trace
SRC=192.168.7.1 DST=192.168.7.10 LEN=88 TTL=64 ID=39366 PROTO=6 SPT=47028 DPT=22 raw prerouting (# handle 6)
        ip protocol tcp limit rate 1/second nftrace set 1
RETURN raw prerouting
ACCEPT raw prerouting
filter input (# handle 7)
        tcp dport ssh jump foo
filter foo (# handle 5)
        ip daddr 192.168.7.10
filter foo (# handle 6)
        counter packets 912 bytes 63619
RETURN filter foo
filter input (# handle 8)
        ip protocol tcp ip daddr 192.168.7.10
filter input (# handle 9)
        tcp dport ssh accept

So basic functionality works on current nftables head.

However, the code uses nfnetlink_log.  It appears that its
unicast only, i.e. its not possible to run another 'nft trace' in parallel
and also clashes with ulogd or other running logger.

Thats a non-starter.

So I'm inclined to toss the nfnetlink_log based changes and
instead (re-)use the infrastructure that we have for chain, rule, ... notifications.

That would mean i'd also just plug the tracing notifications decoding into nft monitor.

Is that ok?
Any better ideas?

Do you think its useful to also dump skb data (i.e. in/outdev,
packet payload, etc?)

Thanks,
Florian
