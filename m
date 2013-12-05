From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: libmnl [PATCH 1/5] examples: set attr table
Date: Thu, 5 Dec 2013 19:16:06 +0900
Message-ID: <CAGCkEt1_mew78vbG88Jk79eFAuZcADMTzt0mr=t_us7fe1EUyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:55243 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LEKQH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:16:07 -0500
Received: by mail-qe0-f54.google.com with SMTP id cy11so15170676qeb.41
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 02:16:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Thu, 7 Nov 2013 16:45:41 +0900
Subject: [PATCH 1/5] examples: set attr table

---
 examples/rtnl/rtnl-route-dump.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 59e0a9d..33cb2df 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -13,6 +13,8 @@

 static int data_attr_cb2(const struct nlattr *attr, void *data)
 {
+       const struct nlattr **tb = data;
+
        /* skip unsupported attribute in user-space */
        if (mnl_attr_type_valid(attr, RTAX_MAX) < 0)
                return MNL_CB_OK;
@@ -21,6 +23,8 @@ static int data_attr_cb2(const struct nlattr *attr,
void *data)
                perror("mnl_attr_validate");
                return MNL_CB_ERROR;
        }
+
+       tb[mnl_attr_get_type(attr)] = attr;
        return MNL_CB_OK;
 }

--
1.7.10.4
