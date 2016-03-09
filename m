From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft] proto: Add router advertisement and solicitation icmp
 types
Date: Wed, 9 Mar 2016 19:53:07 +0100
Message-ID: <20160309185304.GA13575@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35421 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcCISxM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 13:53:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id n205so346666wmf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Mar 2016 10:53:11 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enable support for router-advertisement and router-solicitation icmp types in nft.

Example:
$ sudo nft add rule ip filter input icmp type router-advertisement counter accept
$ sudo nft add rule ip filter input icmp type router-solicitation counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index 0ed98ed..b54a4c1 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -299,6 +299,8 @@ static const struct symbol_table icmp_type_tbl = {
 		SYMBOL("source-quench",			ICMP_SOURCE_QUENCH),
 		SYMBOL("redirect",			ICMP_REDIRECT),
 		SYMBOL("echo-request",			ICMP_ECHO),
+		SYMBOL("router-advertisement",		ICMP_ROUTERADVERT),
+		SYMBOL("router-solicitation",		ICMP_ROUTERSOLICIT),
 		SYMBOL("time-exceeded",			ICMP_TIME_EXCEEDED),
 		SYMBOL("parameter-problem",		ICMP_PARAMETERPROB),
 		SYMBOL("timestamp-request",		ICMP_TIMESTAMP),
-- 
2.7.0

