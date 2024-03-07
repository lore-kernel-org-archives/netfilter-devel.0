Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C232366
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.212.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709856196; cv=none; b=aRoYa5fE1Aah1XPqJSAYDD+eaKW1S3ykXQZG52YANMFigkq7jjwQI6yOPjiTmbi9rMdVIF40p+jteKsugy768fsUAZ1NYJOBGi6+uRflsFIvQfIlHM2GSwM96iD8OuUn1py3faBRBDrzC6F9cyxWu3L62BmiCKdcdbI582MTDEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709856196; c=relaxed/simple;
	bh=rmIwWdl3EpX/jesAsBZKUDb0vAZXhwmHeZebb8JWXgI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dGeXQlXugUlnIWSpuDtT6vFJSu61ZmZD81fIR69/UfuHE6NL18KyTFc0gv/WfSPyLlZAUoXRgS9iINlEJ99p0jk4FKiUvbU+bmtL/H90mDTKq9OWar4tgfnFg7yKT4qRyixp2t8+aY5J/wSOvR89E0HAUNmNbk+AKiWlzdems4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de; spf=pass smtp.mailfrom=sysmocom.de; arc=none smtp.client-ip=176.9.212.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sysmocom.de
Received: from localhost (localhost [127.0.0.1])
	by mail.sysmocom.de (Postfix) with ESMTP id 631CC198165C
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 23:54:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
	by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yirbe5B7X0Kc; Thu,  7 Mar 2024 23:54:28 +0000 (UTC)
Received: from my.box (ip-109-40-241-33.web.vodafone.de [109.40.241.33])
	by mail.sysmocom.de (Postfix) with ESMTPSA id 9C7D5198062D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 23:54:28 +0000 (UTC)
Date: Fri, 8 Mar 2024 00:54:27 +0100
From: Neels Hofmeyr <nhofmeyr@sysmocom.de>
To: netfilter-devel@vger.kernel.org
Subject: [RFC nftables PATCH]: fix a2x: ERROR: missing --destination-dir:
 ./doc
Message-ID: <ZepTs5Rj0bXqQvSo@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kGTWViPtwtEYGIeA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--kGTWViPtwtEYGIeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Since recently, I'm getting this build error from nftables, quite definitely
because I am building in a separate directory, and not in the source tree
itself.

	  GEN      doc/nft.8
	  GEN      doc/libnftables-json.5
	  GEN      doc/libnftables.3
	a2x: ERROR: missing --destination-dir: ./doc

	make[2]: *** [Makefile:1922: doc/nft.8] Error 1

May I suggest attached patch.

An alternative might be an entry in AC_CONFIG_FILES? In the source trees at
osmocom we usually have a Makefile generated in each output dir, which solves
any missing directory problems.

I haven't investigated the cause, maybe it is some change on my system that
suddenly exposes this; there was some serious package upgrading going on half
an hour ago.

Thanks!

~N

-- 
- Neels Hofmeyr <nhofmeyr@sysmocom.de>          http://www.sysmocom.de/
=======================================================================
* sysmocom - systems for mobile communications GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschäftsführer / Managing Directors: Harald Welte

--kGTWViPtwtEYGIeA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-mkdir-builddir-doc.patch"

From b15204aa58c09d2a9368aa6c074be086fc481ece Mon Sep 17 00:00:00 2001
From: Neels Hofmeyr <nhofmeyr@sysmocom.de>
Date: Fri, 8 Mar 2024 00:42:50 +0100
Subject: [PATCH] mkdir $(builddir}/doc

When building separately from the source tree (as in ../src/configure),
the 'doc' dir is not present from just the source tree. Create the dir
before calling a2x.
---
 Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.am b/Makefile.am
index 688a9849..fef1d8d1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -342,6 +342,7 @@ EXTRA_DIST += \
 CLEANFILES += doc/*~
 
 doc/nft.8: $(ASCIIDOCS)
+	mkdir -p ${builddir}/doc
 	$(AM_V_GEN)$(A2X) $(A2X_OPTS_MANPAGE) $<
 
 .adoc.3:
-- 
2.43.0


--kGTWViPtwtEYGIeA--
