From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 03/17] xtables_ip6addr_to_numeric: fix typo in comment
Date: Thu, 31 Mar 2011 21:27:19 -0700
Message-ID: <1301632053-3694-3-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DAE2O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:14 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:14 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

An IPv6 address consists of eight hexadecimal 16-bit values seperated
by colons, or alternatively, six (not five) of these followed by a colo=
n
and an IPv4 address in standard dotted decimal quad notation
(for IPv4 mapped addresses and the like).

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index 352963f..7d36742 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1336,7 +1336,7 @@ void xtables_ipparse_any(const char *name, struct=
 in_addr **addrpp,
=20
 const char *xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
 {
-	/* 0000:0000:0000:0000:0000:000.000.000.000
+	/* 0000:0000:0000:0000:0000:0000:000.000.000.000
 	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
 	static char buf[50+1];
 	return inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
