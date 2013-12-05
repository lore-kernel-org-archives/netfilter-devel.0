From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: libmnl [PATCH 5/5] attr: validate MNL_TYPE_MSEC same as MNL_TYPE_U64
Date: Thu, 5 Dec 2013 19:17:38 +0900
Message-ID: <CAGCkEt2O0xv_EuEyODD=68UYvELnkGpwcaY7UVbSejZhKTF8ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35386 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LEKRj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:17:39 -0500
Received: by mail-qc0-f175.google.com with SMTP id e9so4573464qcy.6
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 02:17:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Tue, 3 Dec 2013 09:29:24 +0900
Subject: [PATCH 5/5] attr: validate MNL_TYPE_MSEC same as MNL_TYPE_U64

---
 src/attr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/attr.c b/src/attr.c
index 1136c50..c3c57e6 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -200,6 +200,7 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
        [MNL_TYPE_U16]          = sizeof(uint16_t),
        [MNL_TYPE_U32]          = sizeof(uint32_t),
        [MNL_TYPE_U64]          = sizeof(uint64_t),
+       [MNL_TYPE_MSECS]        = sizeof(uint64_t),
 };

 /**
--
1.7.10.4
