From: marty <martinbarrowcliff@gmail.com>
Subject: Re: Ulogd - mysql addresses are in network-byte order
Date: Mon, 02 Jan 2012 00:03:46 -0500
Message-ID: <4F013AB2.8030004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58250 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2ABFDu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:03:50 -0500
Received: by qcqz2 with SMTP id z2so9200732qcq.19
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Jan 2012 21:03:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Here, for your review is a patch to
address the issue that I reported.

--- orig.ulogd_raw2packet_BASE.c	2011-12-08 11:55:09.000000000 -0500
+++ ulogd_raw2packet_BASE.c	2012-01-01 23:40:14.000000000 -0500
@@ -717,8 +717,8 @@
  		return ULOGD_IRET_OK;
  	len -= iph->ihl * 4;

-	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
-	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
+	okey_set_u32(&ret[KEY_IP_SADDR], ntohl(iph->saddr));
+	okey_set_u32(&ret[KEY_IP_DADDR], ntohl(iph->daddr));
  	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
  	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
  	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);


Marty B.
