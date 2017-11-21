From: Phil Sutter <phil@nwl.cc>
Subject: nftables: lockout with 0008split_tables_0 test
Date: Tue, 21 Nov 2017 12:15:56 +0100
Message-ID: <20171121111556.GX32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44992 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751876AbdKULP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2017 06:15:58 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is about tests/shell/testcases/nft-f/0008split_tables_0, which adds
the following simple ruleset:

| table inet filter {
|         chain ssh {
|                 type filter hook input priority 0; policy accept;
|                 tcp dport ssh accept;
|         }
| }
| 
| table inet filter {
|         chain input {
|                 type filter hook input priority 1; policy drop;
|         }
| }

If applied, it kills my SSH connection. :(

I changed the ruleset for debugging purposes to this one:

| table inet filter {
|         chain ssh {
|               type filter hook input priority 0; policy accept;
| 		meta nftrace set 1
| 		accept
|         }
| }
| 
| table inet filter {
|         chain input {
|               type filter hook input priority 1; policy drop;
| 		meta nftrace set 1
|         }
| }

So I've changed the rule in chain 'ssh' to allow everything and enabled
tracing. Looking at trace output, I see this:

| trace id 4a1d1b92 inet filter ssh packet: iif "eth0" ether saddr fe:07:ef:9f:d5:dd ether daddr 52:54:ff:12:34:56 ip6 saddr fec0:42::1 ip6 daddr fec0:42::24 ip6 dscp 0x02 ip6 ecn not-ect ip6 hoplimit 64 ip6 flowlabel 871503 ip6 length 280 tcp sport 59068 tcp dport ssh tcp flags == 0x19 tcp window 1412 
| trace id 4a1d1b92 inet filter ssh rule nftrace set 1 (verdict continue)
| trace id 4a1d1b92 inet filter ssh rule accept (verdict accept)
| trace id 4a1d1b92 inet filter input packet: iif "eth0" ether saddr fe:07:ef:9f:d5:dd ether daddr 52:54:ff:12:34:56 ip6 saddr fec0:42::1 ip6 daddr fec0:42::24 ip6 dscp 0x02 ip6 ecn not-ect ip6 hoplimit 64 ip6 flowlabel 871503 ip6 length 280 tcp sport 59068 tcp dport ssh tcp flags == 0x19 tcp window 1412 
| trace id 4a1d1b92 inet filter input rule nftrace set 1 (verdict continue)
| trace id 4a1d1b92 inet filter input verdict continue 
| trace id 4a1d1b92 inet filter input 

It shows that given packet traverses both chains instead of only the
first one as I would have expected and therefore drop policy of chain
'input' applies instead of the 'accept' verdict in chain 'ssh'.

Is this desired behaviour or is there a bug in chain traversal?

I tested using current nf-next tree, but comparing it's history to that
of current net doesn't show any change which might be related.

Help?

Cheers, Phil
