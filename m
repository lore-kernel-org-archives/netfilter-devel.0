Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38007C35641
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 07:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE5A20656
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 07:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgBUHAn convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 02:00:43 -0500
Received: from mxout013.mail.hostpoint.ch ([217.26.49.173]:49853 "EHLO
        mxout013.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgBUHAn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 02:00:43 -0500
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2020 02:00:42 EST
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtp (Exim 4.92.3 (FreeBSD))
        (envelope-from <andreas.jaggi@waterwave.ch>)
        id 1j51zJ-0007ez-0H
        for netfilter-devel@vger.kernel.org; Fri, 21 Feb 2020 07:40:37 +0100
Received: from xdsl-31-165-67-144.adslplus.ch ([31.165.67.144] helo=[192.168.9.20])
        by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.92.3 (FreeBSD))
        (envelope-from <andreas.jaggi@waterwave.ch>)
        id 1j51zI-0007R6-Tz
        for netfilter-devel@vger.kernel.org; Fri, 21 Feb 2020 07:40:36 +0100
X-Authenticated-Sender-Id: andreas.jaggi@waterwave.ch
From:   Andreas Jaggi <andreas.jaggi@waterwave.ch>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: [PATCH] ulogd: printpkt: always print IPv6 protocol
Message-Id: <12B140AA-502D-488F-B6A2-9E9DCF1DFC71@waterwave.ch>
Date:   Fri, 21 Feb 2020 07:40:36 +0100
To:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print the protocol number for protocols not known by name.

Signed-off-by: Andreas Jaggi <andreas.jaggi@waterwave.ch>
---
 util/printpkt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/util/printpkt.c b/util/printpkt.c
index 69a47ca..2aacddb 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -355,6 +355,9 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 			break;
 		}
 		break;
+	default:
+		buf_cur += sprintf(buf_cur, "PROTO=%u ",
+				   ikey_get_u8(&res[KEY_IP6_NEXTHDR]));
 	}
 
 	return buf_cur - buf;
-- 
2.25.0
