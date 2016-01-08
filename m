From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] tests: ct: remove BUG cases that work with current master
Date: Fri,  8 Jan 2016 10:42:51 +0100
Message-ID: <1452246171-13943-7-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47946 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932110AbcAHJuu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:50 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have tests for these in ip/ct.t.
(can't use ipv4 addresses e.g. in ipv6 family, thats why any/ct.t doesn't work)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/ct.t | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 4c27c90..14be798 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -67,44 +67,11 @@ ct expiration != 33-45;ok;ct expiration != 33s-45s
 ct expiration {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
 - ct expiration != {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
 ct expiration {33-55};ok;ct expiration { 33s-55s}
-# BUG: ct expiration {33-55}
-# Broken output: ct expiration { "4271d23h25m52s"-"8738d3h11m59s" }
 - ct expiration != {33-55};ok
 
 ct helper "ftp";ok
 ct helper "12345678901234567";fail
 
-# BUG: ct l3proto "Layer  3 protocol of the connection"
-# nft add rule ip test input ct l3proto arp
-# <cmdline>:1:35-37: Error: Can t parse symbolic invalid expressions
-
-
-# If table is ip6 or inet or bridge family,, It is failed. I can not test it
-# ct saddr 1.2.3.4;ok
-
-# BUG: ct saddr 192.168.3.4
-# <cmdline>:1:1-43: Error: Could not process rule: Invalid argument
-# add rule ip test input ct saddr 192.168.3.4
-# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ct saddr 192.168.3.4;ok
-- ct daddr 192.168.3.4;ok
-
-# BUG: ct protocol tcp
-# <cmdline>:1:1-37: Error: Could not process rule: Invalid argument
-# input ct protocol bgp <cmdline>:1:36-38: Error: Could not resolve protocol name
-# ct protocol tcp;ok
-- ct protocol tcp;ok
-
-- ct proto-src udp;ok
-- ct proto-dst udp;ok
-# BUG: ct proto-src udp and ct proto-dst udp
-# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
-# add rule ip test input ct proto-src udp
-#                       ~~~~~~~~~~~~ ^^^
-# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
-# add rule ip test input ct proto-dst udp
-#                        ~~~~~~~~~~~~ ^^^
-
 ct state . ct mark { new . 0x12345678};ok
 ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634};ok
 ct direction . ct mark { original . 0x12345678};ok
-- 
2.4.10

