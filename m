Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8980DC35671
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C6D2072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgBXNW3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:22:29 -0500
Received: from correo.us.es ([193.147.175.20]:53684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgBXNW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 08:22:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B422310FB03
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 14:22:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A56A5DA7B2
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 14:22:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9B1B2DA72F; Mon, 24 Feb 2020 14:22:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16057DA72F;
        Mon, 24 Feb 2020 14:22:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Feb 2020 14:22:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EDBEF42EF4E1;
        Mon, 24 Feb 2020 14:22:14 +0100 (CET)
Date:   Mon, 24 Feb 2020 14:22:20 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, nevola@gmail.com
Subject: Re: [PATCH nft 6/6] tests: nat: add and use maps with both address
 and service
Message-ID: <20200224132220.h7ng2zugf3zl7a73@salvia>
References: <20200224000324.9333-1-fw@strlen.de>
 <20200224000324.9333-7-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rznnr6tvk3a7r22x"
Content-Disposition: inline
In-Reply-To: <20200224000324.9333-7-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rznnr6tvk3a7r22x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have adapted this test to the new syntax, but it stills fails here:

# ./run-tests.sh testcases/maps/nat_addr_port 
I: using nft binary ./../../src/nft

W: [FAILED]     testcases/maps/nat_addr_port: got 1
/dev/stdin:6:20-28: Error: datatype mismatch: expected concatenation of (IPv4 address, internet network service), expression has type IPv4 address
                type ipv4_addr : ipv4_addr . inet_service
                                 ^^^^^^^^^

Attaching the patch to update it.

--rznnr6tvk3a7r22x
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index bd20ae7e..210cab7f 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -19,8 +19,8 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat to ip saddr map @y
-		dnat to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y
+		dnat ip addr . port to ip saddr . tcp dport map @z
 	}
 }
 table ip6 ip6foo {
@@ -42,8 +42,8 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat to ip6 saddr map @y
-		dnat to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
+		dnat ip6 addr . port to ip6 saddr . tcp dport map @z
 	}
 }
 table inet inetfoo {
@@ -78,12 +78,12 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
-		meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4
-		meta nfproto ipv4 dnat ip to ip saddr . tcp dport map @z4
+		meta l4proto tcp meta nfproto ipv4 dnat ip addr . port to ip saddr map @y4
+		meta nfproto ipv4 dnat ip addr . port to ip saddr . tcp dport map @z4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
-		meta l4proto tcp meta nfproto ipv6 dnat ip6 to ip6 saddr map @y6
-		meta nfproto ipv6 dnat ip6 to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr map @y6
+		meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
 	}
 }
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 58bb8942..1a0c8521 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -21,8 +21,8 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat to ip saddr map @y
-		meta l4proto tcp dnat to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y
+		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z
 	}
 }
 EOF
@@ -31,7 +31,7 @@ EOF
 $NFT add rule 'ip ipfoo c ip saddr 10.1.1.2 dnat to 10.2.3.4:4242' && exit 1
 
 # should fail: rule has no test for l4 protocol, but map has inet_service
-$NFT add rule 'ip ipfoo c dnat to ip daddr map @y' && exit 1
+$NFT add rule 'ip ipfoo c dnat ip addr . port to ip daddr map @y' && exit 1
 
 # skeleton 6
 $NFT -f /dev/stdin <<EOF || exit 1
@@ -52,8 +52,8 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat to ip6 saddr map @y
-		meta l4proto tcp dnat to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
+		meta l4proto tcp dnat ip addr . port to ip6 saddr . tcp dport map @z
 	}
 }
 EOF
@@ -93,13 +93,13 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat ip to ip saddr map @y4
-		meta l4proto tcp dnat ip to ip saddr . tcp dport map @z4
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y4
+		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat ip6 to ip6 saddr map @y6
-		meta l4proto tcp dnat ip6 to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y6
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
 	}
 }
 EOF

--rznnr6tvk3a7r22x--
