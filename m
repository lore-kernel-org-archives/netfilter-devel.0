From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH ulogd 1/7] ipfix: add flowDirection IE
Date: Wed, 10 Feb 2016 10:56:30 +0900
Message-ID: <20160210015630.GB17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
 <20160210015358.GA17470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36042 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbcBJB4f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 20:56:35 -0500
Received: by mail-pa0-f68.google.com with SMTP id sv5so234962pab.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 17:56:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210015358.GA17470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/ulogd/ipfix_protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index aef47f0..bff0b5c 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -100,7 +100,7 @@ enum {
 	IPFIX_vlanId			= 58,
 	IPFIX_postVlanId		= 59,
 	IPFIX_ipVersion			= 60,
-	/* reserved */
+	IPFIX_flowDirection		= 61,
 	IPFIX_ipNextHopIPv6Address	= 62,
 	IPFIX_bgpNexthopIPv6Address	= 63,
 	IPFIX_ipv6ExtensionHeaders	= 64,
-- 
2.1.4

