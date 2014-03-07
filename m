From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH] ulogd: fix logleve handling
Date: Fri, 7 Mar 2014 15:43:05 +0900
Message-ID: <CAGCkEt2zMU6N3rp=6F0P4TicWHbhy6+-JMg8W1aQB2tF6EHrrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:42060 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaCGGnH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:43:07 -0500
Received: by mail-la0-f47.google.com with SMTP id y1so2464021lam.6
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Mar 2014 22:43:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was always default if not specified by command parameter.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/ulogd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 2c0fbd1..670a6e2 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1383,9 +1383,10 @@ int main(int argc, char* argv[])
        }

        /* command line has precedence on config file */
-       if (loglevel)
+       if (loglevel) {
                loglevel_ce.u.value = loglevel;
                loglevel_ce.flag |= CONFIG_FLAG_VAL_PROTECTED;
+       }

        if (ulogd_pidfile) {
                if (create_pidfile() < 0)
--
1.8.5.3
