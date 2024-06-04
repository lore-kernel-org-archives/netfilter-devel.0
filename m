Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274F5A5F
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 18:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717526409; cv=none; b=O1XCIlA5Jemhtc9H4pIKozWHJvft3iO1MmO/59OhqFAOhn2VTEsKqG7x+GDLBpOOJGOP3b++gWfgbkbNHJwxA1eEbvAs8HZqbBF9vKttMLuALVQfsW+CtONi9hiqaDMiIQKaV/VdPJKwWZtDFvRv8qvedV7UuSxvMhCr2t2a+gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717526409; c=relaxed/simple;
	bh=/XTXjxjV+XV7zVHN4alWxHeECu7gGeegqCXZZwtfqDY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=QZ00fMWVSfc9yxFAowtJQ0x7zKeCQYHuuqCHJ5/POsM6+X5StYm2MuCMLK1H0r63TW4uJrnnbPMGAbchQ2lk8hEKERPgl4x4ZnOB2lXUGTfjsY3YnTGA2KyXjoT2iCbSGo0G0TKjSaZ9+yUOwdiN6ngjLsOCFvBI+XmrlT2CXec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] scanner: inet_pton() allows for broader IPv4-Mapped IPv6 addresses
Date: Tue,  4 Jun 2024 20:39:53 +0200
Message-Id: <20240604183953.412880-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inet_pton() allows for broader IPv4-Mapped IPv6 address syntax than
those specified by rfc4291. This patch extends the scanner to support
them for compatibility reasons. This allows to represent the last 4
bytes of an IPv6 address as an IPv4 address.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1730
Fixes: fd513de78bc0 ("scanner: IPv4-Mapped IPv6 addresses support")
Fixes: 3f82ef3d0dbf ("scanner: Support rfc4291 IPv4-compatible addresses")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index e4d20e691d00..96c505bcdd48 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -132,48 +132,47 @@ slash		\/
 timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?([0-9]+ms)?
 
 hex4		([[:xdigit:]]{1,4})
+rfc4291_broader	(((:{hex4}){2})|(:{ip4addr}))
 v680		(({hex4}:){7}{hex4})
-v670		((:)((:{hex4}){7}))
-v671		((({hex4}:){1})((:{hex4}){6}))
-v672		((({hex4}:){2})((:{hex4}){5}))
-v673		((({hex4}:){3})((:{hex4}){4}))
-v674		((({hex4}:){4})((:{hex4}){3}))
-v675		((({hex4}:){5})((:{hex4}){2}))
+v670		((:)((:{hex4}){5}){rfc4291_broader})
+v671		((({hex4}:){1})((:{hex4}){4}){rfc4291_broader})
+v672		((({hex4}:){2})((:{hex4}){3}){rfc4291_broader})
+v673		((({hex4}:){3})((:{hex4}){2}){rfc4291_broader})
+v674		((({hex4}:){4})((:{hex4}){1}){rfc4291_broader})
+v675		((({hex4}:){5}){rfc4291_broader})
 v676		((({hex4}:){6})(:{hex4}{1}))
 v677		((({hex4}:){7})(:))
 v67		({v670}|{v671}|{v672}|{v673}|{v674}|{v675}|{v676}|{v677})
-v660		((:)((:{hex4}){6}))
-v661		((({hex4}:){1})((:{hex4}){5}))
-v662		((({hex4}:){2})((:{hex4}){4}))
-v663		((({hex4}:){3})((:{hex4}){3}))
-v664		((({hex4}:){4})((:{hex4}){2}))
+v660		((:)((:{hex4}){4}){rfc4291_broader})
+v661		((({hex4}:){1})((:{hex4}){3}){rfc4291_broader})
+v662		((({hex4}:){2})((:{hex4}){2}){rfc4291_broader})
+v663		((({hex4}:){3})((:{hex4}){1}){rfc4291_broader})
+v664		((({hex4}:){4}){rfc4291_broader})
 v665		((({hex4}:){5})((:{hex4}){1}))
 v666		((({hex4}:){6})(:))
 v66		({v660}|{v661}|{v662}|{v663}|{v664}|{v665}|{v666})
-v650		((:)((:{hex4}){5}))
-v651		((({hex4}:){1})((:{hex4}){4}))
-v652		((({hex4}:){2})((:{hex4}){3}))
-v653		((({hex4}:){3})((:{hex4}){2}))
+v650		((:)((:{hex4}){3}){rfc4291_broader})
+v651		((({hex4}:){1})((:{hex4}){2}){rfc4291_broader})
+v652		((({hex4}:){2})((:{hex4}){1}){rfc4291_broader})
+v653		((({hex4}:){3}){rfc4291_broader})
 v654		((({hex4}:){4})(:{hex4}{1}))
 v655		((({hex4}:){5})(:))
 v65		({v650}|{v651}|{v652}|{v653}|{v654}|{v655})
-v640		((:)((:{hex4}){4}))
-v641		((({hex4}:){1})((:{hex4}){3}))
-v642		((({hex4}:){2})((:{hex4}){2}))
+v640		((:)((:{hex4}){2}){rfc4291_broader})
+v641		((({hex4}:){1})((:{hex4}){1}){rfc4291_broader})
+v642		((({hex4}:){2}){rfc4291_broader})
 v643		((({hex4}:){3})((:{hex4}){1}))
 v644		((({hex4}:){4})(:))
 v64		({v640}|{v641}|{v642}|{v643}|{v644})
-v630		((:)((:{hex4}){3}))
-v631		((({hex4}:){1})((:{hex4}){2}))
+v630		((:)((:{hex4}){1}){rfc4291_broader})
+v631		((({hex4}:){1}){rfc4291_broader})
 v632		((({hex4}:){2})((:{hex4}){1}))
 v633		((({hex4}:){3})(:))
 v63		({v630}|{v631}|{v632}|{v633})
-v620		((:)((:{hex4}){2}))
-v620_rfc4291	((:)(:{ip4addr}))
+v620		((:){rfc4291_broader})
 v621		((({hex4}:){1})((:{hex4}){1}))
 v622		((({hex4}:){2})(:))
-v62_rfc4291	((:)(:[fF]{4})(:{ip4addr}))
-v62		({v620}|{v621}|{v622}|{v62_rfc4291}|{v620_rfc4291})
+v62		({v620}|{v621}|{v622})
 v610		((:)(:{hex4}{1}))
 v611		((({hex4}:){1})(:))
 v61		({v610}|{v611})
-- 
2.30.2

