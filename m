From: Andreas Herz <andi@geekosphere.org>
Subject: broken packet passed into raw table by nf_defrag_ipv6
Date: Thu, 3 Sep 2015 15:57:55 +0200
Message-ID: <20150903135755.GX29140@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:38471 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbbICN55 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 09:57:57 -0400
Received: from geekosphere.org (unknown [IPv6:2a00:f48:1026:0:f1f7:0:1545:173f])
	by mail.geekosphere.org (Postfix) with ESMTPSA id C0F02FA233
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2015 13:57:55 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There seems to be a bug or wrong behaviour in nf_defrag_ipv6.
I'm sending a fragmented ipv6 icmpv6 packet with thc-tools:

> atk6-implementation6 eth1 2001:db8:f00d:1::defe:d2 -p 15
> (overlap-first-dst fragmentation)

a) If nf_defrag_ipv6 is off i get the following dump with 2 fragments:

http://62.113.242.158/frag.pcap

b) If nf_defrag_ipv6 is on i get the following dump with 1 fragment:

http://62.113.242.158/defrag.pcap

I'm using a debian system with kernel 4.1 and just this rules in the raw
table PREROUTING:

NFLOG all * * ::/0 ::/0 nflog-group 10 (for dumping the packet)
LOG all * * ::/0 ::/0 LOG flags 0 level 4
LOG tcp * * ::/0 ::/0 LOG flags 0 level 4
LOG all * * ::/0 ::/0 LOG flags 0 level 4

In a) i see the first fragment passing all rules and the second fragment
is dropped when it reaches the LOG rule with the -p tcp match. fw
pointed out that this is the hotdrop that triggers since the second
fragment is invalid it seems (maybe some can explain why the second
fragment won't pass this match). So this seems to be correct behaviour
although i'm not 100% sure why the first fragment passes the tcp match
and the second does not.

Some explanation is found in commit from 2006
6d381634d213580d40d431e7664dfb45f641b884 and in net/ipv6/exthdrs_core.c

The IMHO bug is in b) because the packet that enters the raw table which
was "modified" by nf_defrag_ipv6 is obviously invalid since it's missing
the destination header that's declared in the nh part from the fragment
header and the protocol header is completely missing.

There would be two solutions, if you agree that this is a bug:

1) drop this packet already in nf_defrag_ipv6 since it's messed up
2) try to defrag it correct

Thanks!

-- 
Andreas Herz
