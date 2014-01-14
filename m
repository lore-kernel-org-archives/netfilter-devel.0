From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] nft: scanner: fixed problem with ipv6 address
Date: Tue, 14 Jan 2014 20:25:56 +0100
Message-ID: <1389727556-9568-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33950 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANT0G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:26:06 -0500
Received: by mail-wi0-f171.google.com with SMTP id cc10so3068433wib.10
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2014 11:26:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a problem with the follow ipv6 address combination:

nft add rule ip6 t_ip61 filter-input ip6 saddr ::1234:1234:1234:1234:1234:1234:1234

1234::1234:1234:1234:1234:1234:1234
1234:1234::1234:1234:1234:1234:1234
1234:1234:1234::1234:1234:1234:1234
1234:1234:1234:1234::1234:1234:1234
1234:1234:1234:1234:1234::1234:1234
::1234:1234:1234:1234:1234:1234
1234::1234:1234:1234:1234:1234
1234:1234::1234:1234:1234:1234
1234:1234:1234::1234:1234:1234
1234:1234:1234:1234::1234:1234
::1234:1234:1234:1234:1234
1234::1234:1234:1234:1234
1234:1234::1234:1234:1234
1234:1234:1234::1234:1234
::1234:1234:1234:1234
1234::1234:1234:1234
1234:1234::1234:1234
::1234:1234:1234
1234::1234:1234

The problem was in the scanner (src/scanner.l). Several brackets were missed
and the result was an incorrect interpretation.

Fix it by adding some brackets in a regular expression in src/scanner.l

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/scanner.l | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index ee71492..345b131 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -118,43 +118,43 @@ slash		\/
 
 hex4		([[:xdigit:]]{1,4})
 v680		(({hex4}:){7}{hex4})
-v670		((:)(:{hex4}{7}))
-v671		((({hex4}:){1})(:{hex4}{6}))
-v672		((({hex4}:){2})(:{hex4}{5}))
-v673		((({hex4}:){3})(:{hex4}{4}))
-v674		((({hex4}:){4})(:{hex4}{3}))
-v675		((({hex4}:){5})(:{hex4}{2}))
+v670		((:)((:{hex4}){7}))
+v671		((({hex4}:){1})((:{hex4}){6}))
+v672		((({hex4}:){2})((:{hex4}){5}))
+v673		((({hex4}:){3})((:{hex4}){4}))
+v674		((({hex4}:){4})((:{hex4}){3}))
+v675		((({hex4}:){5})((:{hex4}){2}))
 v676		((({hex4}:){6})(:{hex4}{1}))
 v677		((({hex4}:){7})(:))
 v67		({v670}|{v671}|{v672}|{v673}|{v674}|{v675}|{v676}|{v677})
-v660		((:)(:{hex4}{6}))
-v661		((({hex4}:){1})(:{hex4}{5}))
-v662		((({hex4}:){2})(:{hex4}{4}))
-v663		((({hex4}:){3})(:{hex4}{3}))
-v664		((({hex4}:){4})(:{hex4}{2}))
-v665		((({hex4}:){5})(:{hex4}{1}))
+v660		((:)((:{hex4}){6}))
+v661		((({hex4}:){1})((:{hex4}){5}))
+v662		((({hex4}:){2})((:{hex4}){4}))
+v663		((({hex4}:){3})((:{hex4}){3}))
+v664		((({hex4}:){4})((:{hex4}){2}))
+v665		((({hex4}:){5})((:{hex4}){1}))
 v666		((({hex4}:){6})(:))
 v66		({v660}|{v661}|{v662}|{v663}|{v664}|{v665}|{v666})
-v650		((:)(:{hex4}{5}))
-v651		((({hex4}:){1})(:{hex4}{4}))
-v652		((({hex4}:){2})(:{hex4}{3}))
-v653		((({hex4}:){3})(:{hex4}{2}))
+v650		((:)((:{hex4}){5}))
+v651		((({hex4}:){1})((:{hex4}){4}))
+v652		((({hex4}:){2})((:{hex4}){3}))
+v653		((({hex4}:){3})((:{hex4}){2}))
 v654		((({hex4}:){4})(:{hex4}{1}))
 v655		((({hex4}:){5})(:))
 v65		({v650}|{v651}|{v652}|{v653}|{v654}|{v655})
-v640		((:)(:{hex4}{4}))
-v641		((({hex4}:){1})(:{hex4}{3}))
-v642		((({hex4}:){2})(:{hex4}{2}))
-v643		((({hex4}:){3})(:{hex4}{1}))
+v640		((:)((:{hex4}){4}))
+v641		((({hex4}:){1})((:{hex4}){3}))
+v642		((({hex4}:){2})((:{hex4}){2}))
+v643		((({hex4}:){3})((:{hex4}){1}))
 v644		((({hex4}:){4})(:))
 v64		({v640}|{v641}|{v642}|{v643}|{v644})
-v630		((:)(:{hex4}{3}))
-v631		((({hex4}:){1})(:{hex4}{2}))
-v632		((({hex4}:){2})(:{hex4}{1}))
+v630		((:)((:{hex4}){3}))
+v631		((({hex4}:){1})((:{hex4}){2}))
+v632		((({hex4}:){2})((:{hex4}){1}))
 v633		((({hex4}:){3})(:))
 v63		({v630}|{v631}|{v632}|{v633})
-v620		((:)(:{hex4}{2}))
-v621		((({hex4}:){1})(:{hex4}{1}))
+v620		((:)((:{hex4}){2}))
+v621		((({hex4}:){1})((:{hex4}){1}))
 v622		((({hex4}:){2})(:))
 v62		({v620}|{v621}|{v622})
 v610		((:)(:{hex4}{1}))
-- 
1.8.5.2

