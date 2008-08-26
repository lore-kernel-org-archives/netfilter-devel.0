From: "luo kaih" <kaih.luo@gmail.com>
Subject: [PATCH] netfilter: xt_time: never matches a correct monthday in a leap year after 28th 2
Date: Tue, 26 Aug 2008 11:07:05 +0800
Message-ID: <c0ff893e0808252007p72cd9676j437a72024b71612c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.238]:30671 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYHZDHG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2008 23:07:06 -0400
Received: by qb-out-0506.google.com with SMTP id a16so2978115qbd.17
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2008 20:07:06 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the function localtime_3 in xt_time.c  gives a wrong monthday in a
leap year after 28th 2 . calculating monthday should use the array
days_since_leapyear[] not days_since_year[]  in a leap year .

From: Kaihui Luo <kaih.luo@gmail.com>

Signed-off-by: Kaihui Luo <kaih.luo@gmail.com>

---
--- linux-2.6.26/net/netfilter/xt_time.c.orig   2008-08-25
11:59:46.000000000 +0800
+++ linux-2.6.26/net/netfilter/xt_time.c        2008-08-25
12:16:12.000000000 +0800
@@ -136,17 +136,19 @@ static void localtime_3(struct xtm *r, t
       * from w repeatedly while counting.)
       */
      if (is_leap(year)) {
+               /* use days_since_leapyear[] in a leap year */
              for (i = ARRAY_SIZE(days_since_leapyear) - 1;
-                   i > 0 && days_since_year[i] > w; --i)
+                   i > 0 && days_since_leapyear[i] > w; --i)
                      /* just loop */;
+               r->monthday = w - days_since_leapyear[i] + 1;
      } else {
              for (i = ARRAY_SIZE(days_since_year) - 1;
                  i > 0 && days_since_year[i] > w; --i)
                      /* just loop */;
+               r->monthday = w - days_since_year[i] + 1;
      }
      r->month    = i + 1;
-       r->monthday = w - days_since_year[i] + 1;
      return;
 }
