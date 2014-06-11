From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of mark
 and zone
Date: Thu, 12 Jun 2014 08:42:24 +0900
Message-ID: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:41262 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaFKXm0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:42:26 -0400
Received: by mail-la0-f41.google.com with SMTP id hz20so268674lab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 16:42:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables comparison of 0 value with mark and zone since
both CTA_MARK and CTA_ZONE are not set in case of its value is 0.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/compare.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index f4a194a..06edd0d 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -24,8 +24,12 @@ static int __cmp(int attr,
        } else if (!a && !b) {
                return 1;
        } else if (flags & NFCT_CMP_MASK &&
-                  test_bit(attr, ct1->head.set)) {
-               return 0;
+                  !test_bit(attr, ct1->head.set)) {
+               return 1;
+       } else if (attr == ATTR_MARK) {
+               return ct1->mark == 0 && ct2->mark == 0;
+       } else if (attr == ATTR_ZONE) {
+               return ct1->zone == 0 && ct2->zone == 0;
        } else if (flags & NFCT_CMP_STRICT) {
                return 0;
        }
--
1.9.1
