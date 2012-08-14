From: Florian Weimer <fweimer@redhat.com>
Subject: [PATCH] mnl_attr_get_str: document that the result is not NUL-terminated
Date: Tue, 14 Aug 2012 12:19:16 +0200
Message-ID: <502A2624.6050701@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070407050204050505010108"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab2HNKTS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:19:18 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7EAJIKw005442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Aug 2012 06:19:18 -0400
Received: from dhcp-5-241.str.redhat.com (dhcp-5-241.str.redhat.com [10.32.5.241])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q7EAJGve010760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Aug 2012 06:19:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070407050204050505010108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

while reviewing from libmnl-using code, I discovered that the result of 
mnl_attr_get_str was used as a NUL-terminated string, although in 
reality the string wasn't.  I think this should be mentioned in the 
documentation.

Florian
-- 
Florian Weimer / Red Hat Product Security Team

--------------070407050204050505010108
Content-Type: text/x-patch;
 name="0001-mnl_attr_get_str-document-that-the-result-is-not-NUL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mnl_attr_get_str-document-that-the-result-is-not-NUL.pa";
 filename*1="tch"

>From 1e4b192907eb15f4fbfd581c8c0fa8359aa9439f Mon Sep 17 00:00:00 2001
From: Florian Weimer <fweimer@redhat.com>
Date: Tue, 14 Aug 2012 12:16:32 +0200
Subject: [PATCH] mnl_attr_get_str: document that the result is not
 NUL-terminated

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 src/attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 1136c50..c890bf2 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -393,6 +393,7 @@ EXPORT_SYMBOL(mnl_attr_get_u64);
  * \param attr pointer to netlink attribute
  *
  * This function returns the payload of string attribute value.
+ * Note that the string is not necessarily NUL-terminated.
  */
 const char *mnl_attr_get_str(const struct nlattr *attr)
 {
-- 
1.7.7.6


--------------070407050204050505010108--
