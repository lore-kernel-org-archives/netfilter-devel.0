Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB911707
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709938786; cv=none; b=ZTjpSi7fT8zb0boR/B5uKF0ZBl4hCcfVeTZ9cUXneJEBjegVmJcFXgd1hCo+OS9+hxyMwoxiVZlIhHIzX7IFKKY6RnGuxrjybGbIK0cnTbTzAULb8D/ux19+Nis5Mk8P++7IkUdN0Nq3Gmxl+vsMhYfGzB+soBabO1MacAh/XoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709938786; c=relaxed/simple;
	bh=45iGGicYGbar+UCQn7WZkSdkc/kZLEnxZM7SALvMLCc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XhLLjAAncXK8A/ss6IAx5Jh/C/RAbYjsLldJIgT1+CYKIzw/JH64T9QgSGK0luATObyFSMz2m1kgP1+ZRE/Umy0WaMzKV+QcWmBg/EdBH5k5ln2djdusLZOZWsOZSJ5lUc+Fs/7GN7ecBMqvLryZzXfL7Juo1MUzFkqD8teLnok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=SnMamA/V; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SnMamA/V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nv9pihroFSrjP9XJL9X7v49QKPbOd4o9tJyFc4bGSlE=; b=SnMamA/VsxTJQuPFexooRD2+g6
	godRPTYx0WoQGhEfd18MNJOA0gt/8tcMAdFyeg7gnyrEZFk+Uub5Mocd6u1zfnKjqhihuiO/et/BV
	CPbLMjuSa/3zGovO4zFpD9my6Slbm05E+pTPuMe5yGpJdF3Dnht904CAFC9RrhTka9QFKrwkMzAbC
	J2rqlS8pLQgc/D5h8zV+xalFpJkXj3qMDDYka6sanwdlN0vUkmPi4jzWqNuFULI+2r9YVu8Jjjrv/
	hjfIRrBh0cWtuFulapq7FiL1uM88x7e33x54oQtKkSZHoBigeFSimmIdgIwCJteTASKf+36ZzLY3Y
	CB7vuUsQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1riiWu-008vha-1w
	for netfilter-devel@vger.kernel.org;
	Fri, 08 Mar 2024 22:17:28 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH arptables] Fix a couple of spelling errors
Date: Fri,  8 Mar 2024 22:17:20 +0000
Message-ID: <20240308221720.639060-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

One mistake in a man-page, one in a warning.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 arptables-legacy.8 | 2 +-
 arptables.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arptables-legacy.8 b/arptables-legacy.8
index 3ce99e375700..f8b630fe3ad9 100644
--- a/arptables-legacy.8
+++ b/arptables-legacy.8
@@ -210,7 +210,7 @@ of the
 .B arptables
 kernel table.
 
-.SS MISCELLANOUS COMMANDS
+.SS MISCELLANEOUS COMMANDS
 .TP
 .B "-V, --version"
 Show the version of the arptables userspace program.
diff --git a/arptables.c b/arptables.c
index 2b6618c2511e..403dae4ae4ac 100644
--- a/arptables.c
+++ b/arptables.c
@@ -844,7 +844,7 @@ parse_interface(const char *arg, char *vianame, unsigned char *mask)
 			if (!isalnum(vianame[i]) 
 			    && vianame[i] != '_' 
 			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
+				printf("Warning: weird character in interface"
 				       " `%s' (No aliases, :, ! or *).\n",
 				       vianame);
 				break;
-- 
2.43.0

