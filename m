From: Andreas Schultz <aschultz@tpip.net>
Subject: nftables queue target aborts rules processing unconditionally
Date: Fri, 3 Mar 2017 16:01:39 +0100 (CET)
Message-ID: <1942735443.286636.1488553299817.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:50172 "EHLO mail.tpip.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdCCPTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 10:19:53 -0500
Received: from office.tpip.net (unknown [153.92.65.89])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.tpip.net (Postfix) with ESMTPS id D94CB4F404
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 15:01:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by office.tpip.net (Postfix) with ESMTP id BBEC3A2BEC
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 16:01:40 +0100 (CET)
Received: from office.tpip.net ([127.0.0.1])
        by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NavuPA74XDn7 for <netfilter-devel@vger.kernel.org>;
        Fri,  3 Mar 2017 16:01:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by office.tpip.net (Postfix) with ESMTP id 20E85A2BED
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 16:01:40 +0100 (CET)
Received: from office.tpip.net ([127.0.0.1])
        by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HA9SUcg76_iN for <netfilter-devel@vger.kernel.org>;
        Fri,  3 Mar 2017 16:01:40 +0100 (CET)
Received: from office.tpip.net (office.tpip.net [153.92.65.89])
        by office.tpip.net (Postfix) with ESMTP id F4021A2BEC
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 16:01:39 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The nft queueing seems to have broken the continuation of
rule processing when NF_ACCEPT is returned.

If have the following rules:

table ip filter {
	map client_to_any {
		type ipv4_addr : verdict
		elements = { 10.180.200.72 : goto CIn_1}
	}

	chain FORWARD {
		type filter hook forward priority 0; policy accept;
		iif { "eth0"} counter packets 1 bytes 84 goto client_to_any

	chain client_to_any {
		nftrace set 1 # handle 11
		counter packets 1 bytes 84 ip saddr vmap @client_to_any # handle 12
		counter packets 1 bytes 84 queue num 0 # handle 13
		counter packets 0 bytes 0 # handle 14
		counter packets 0 bytes 0 ip saddr vmap @client_to_any # handle 16
		goto DENY # handle 17
	}

}

The idea is that the first packet for an yet unknown client will
bypass rules #12, match rule 13 and land in queue 0. The userspace
process then generates the appropriate rules and return an NF_ACCEPT
on the queue.

This should continue the rule processing at rule #14 and finally
match on the update vmap in rule #16.

The problem is that the rule processing is not continuing as
you can see on the counters.

http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.txt
clearly states:

> 1. NF_ACCEPT: continue traversal as normal.

So, why is the processing aborted?

It also appears as if the nft trace infrastructure does not now how to
deal with queues. The above rules lead to this annotated trace output:

> trace id 10d53daf ip filter client_to_any packet: iif "upstream" oif "ens256" ether saddr 00:50:56:96:9b:1c ether daddr 00:0c:29:46:1f:53 ether type ip6 

That's rule #11... Where is the hit on the queue rule and the return??

> add chain ip filter CIn_1
> add rule ip filter CIn_1 counter name "CIn_1_Session"
> add rule ip filter CIn_1 ip daddr 172.20.16.0/24 counter packets 0 bytes 0 accept
> add rule ip filter CIn_1 ip daddr 8.0.0.0/8 counter packets 0 bytes 0 accept
> add chain ip filter COut_1
> add rule ip filter COut_1 counter name "COut_1_Session"
> add rule ip filter COut_1 ip saddr 172.20.16.0/24 counter packets 0 bytes 0 accept
> add rule ip filter COut_1 ip saddr 8.0.0.0/8 counter packets 0 bytes 0 accept

This is the userspace process updating the rules. But the update of the
client_to_any verdict map is missing.

> trace id 10d53daf ip mangle POSTROUTING verdict continue 
> trace id 10d53daf ip mangle POSTROUTING 

The packets skipped the filter table processing completely. Not even the
application of the default accept policy is logged....

Also of this have been tested on net-next and nftables snapshot from 2017-03-01.

The missing trace are only cosmetic (albeit confusing during debugging), but
that the queue aborts the rule processing seems to be a bug.

Regards
Andreas
