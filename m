From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [ulogd2 PATCH] Fix bracket imbalance if IPPROTO_SCTP is defined
Date: Wed, 24 Aug 2011 18:31:02 +0200
Message-ID: <4E552746.4020000@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:39948 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1HXQbG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:31:06 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 49CCE30140
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:31:04 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 13B7E2AC54
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:31:04 +0200 (CEST)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 01CAF2AC52
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:31:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Detected by cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 output/ulogd_output_IPFIX.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 025faab..f7856d2 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -406,6 +406,7 @@ static int open_connect_socket(struct ulogd_pluginstance *pi)
 				freeaddrinfo(resave);
 				return ret;
 			}
+		}
 #endif
 
 		if (connect(ii->fd, res->ai_addr, res->ai_addrlen) != 0) {
-- 
1.7.4.4

