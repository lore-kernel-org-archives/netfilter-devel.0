From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH 2/8] ipfix: fix enterprise bit handling
Date: Sat, 8 Mar 2014 10:09:11 +0900
Message-ID: <20140308010909.GC4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37877 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCHBJU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:09:20 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz1so4865789pad.21
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:09:19 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id ha2sm41172530pbb.8.2014.03.07.17.09.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:09:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If this bit is zero, the Information Element identifier identifies an
Information Element in IANA-IPFIX, and the four-octet Enterprise Number field
MUST NOT be present.
---
 output/ulogd_output_IPFIX.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 01ac9a0..333d532 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -182,15 +182,15 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 			struct ipfix_ietf_field *field = 
 				(struct ipfix_ietf_field *) tmpl->tmpl_cur;
 
-			field->type = htons(key->ipfix.field_id | 0x8000000);
+			field->type = htons(key->ipfix.field_id);
 			field->length = htons(length);
 			tmpl->tmpl_cur += sizeof(*field);
 		} else {
 			struct ipfix_vendor_field *field =
 				(struct ipfix_vendor_field *) tmpl->tmpl_cur;
 
+			field->type = htons(key->ipfix.field_id | 0x8000);
 			field->enterprise_num = htonl(key->ipfix.vendor);
-			field->type = htons(key->ipfix.field_id);
 			field->length = htons(length);
 			tmpl->tmpl_cur += sizeof(*field);
 		}
-- 
1.8.5.3

