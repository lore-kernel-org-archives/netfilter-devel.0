From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 3/13] ipfix: fix enterprise bit handling
Date: Mon, 28 Apr 2014 20:45:36 +0900
Message-ID: <20140428114536.GD12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63574 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaD1Lpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:45:43 -0400
Received: by mail-pd0-f172.google.com with SMTP id w10so5657394pde.3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:45:42 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id gz11sm34553586pbd.1.2014.04.28.04.45.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:45:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
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
1.9.1

