From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 2/8] ipfix: fix enterprise bit handling
Date: Wed, 26 Mar 2014 21:18:00 +0900
Message-ID: <20140326121758.GC24689@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <1395600620.23474.18.camel@ice-age2.regit.org>
 <20140326121122.GA24689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40098 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaCZMSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:18:07 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so1785358pdj.41
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:18:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140326121122.GA24689@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If this bit is zero, the Information Element identifier identifies an
Information Element in IANA-IPFIX, and the four-octet Enterprise Number field
MUST NOT be present.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
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

