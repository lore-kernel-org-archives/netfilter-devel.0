Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E18A267AF6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198334; cv=none; b=PwHHsOLWFh51yN7AiX9K19/k8tatK7O1uebBIL475yXKqaYHD//6jiwdfra+BFiN8EEIaipj3C/M6u38eEtRTEABgulUUEAO30CUG0BMOiWvbxx6g/aoAEpAL6szHzZtT8Op5tJ/6taQ7yEqDhnbaAyLPnULpTMDyLFsHnKGNoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198334; c=relaxed/simple;
	bh=oE4yJkIxxNyLPCn095dKNFVUbU/yZgSXZ4ONcY5cP7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V031P7bDGVfxnYFeF9ItP1+8SCEpEDQdlzqMmHB02NfQiCJwDeCE9k6Os+O0klzzvj5OMirria6KoeJh3gyiJi/gW1axsbKDD0Gbtbg1xCMNvxLa6B+DDnjCqlhq9re10nkCWwN93vlDlD1dh0QXc7QhPnyd1KBxxfvSIluDXCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FMk4UGh1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FMk4UGh1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zBY/fWBXOqFsE+0ISvuKdOv+rlWbAdmphKJjSjfcEg0=; b=FMk4UGh1rBnOy776EJGlK1a7K2
	1JxUtcwR1zdyAMevFzAXjSwW9dJ5TQoYsMNpwOoqbWlRubcuxZMqicmOFEyrjJL+ndGZ8aWCabCsz
	1RzTt5zDGyzhgNzHaYxaYlGQ7IeGgGElDk8yjDiB/cu35bsRQbr2bQARSgDO4P1MkYAprdx4Sqp4A
	1+qvo0+GC3F/gbUuYQSxvLDBeArFpZwHBkHs/UQHyZKODf18zPXm/Pf256U+tQAAsMjzZFFyrnQaQ
	8NzSnQy+HM6tz1S9sLKbCa/GRFwMQf+hSOVKII5IUNSSupSJZqR3wsLa5e7VZeLAYqCcUBJb69MtW
	j9v1L2Nw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueEyQ-000000004di-0uqZ;
	Tue, 22 Jul 2025 17:32:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH] tests: Fix for standalone calls to setlist_resize.sh
Date: Tue, 22 Jul 2025 17:32:05 +0200
Message-ID: <20250722153205.4626-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If called without ip_set.ko loaded, the unconditional 'rmmod ip_set' at
startup will fail and the previous 'set -e' makes that fatal.

Fixes: ed47b815a0d2c ("tests: add namespace test and take into account delayed set removal at module remove")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/setlist_resize.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/setlist_resize.sh b/tests/setlist_resize.sh
index acb33e3ba0f08..db347ca065171 100755
--- a/tests/setlist_resize.sh
+++ b/tests/setlist_resize.sh
@@ -20,7 +20,7 @@ while [ $n -le 9 ]; do
     	n=10
     fi
 done
-rmmod ip_set >/dev/null 2>&1
+rmmod ip_set >/dev/null 2>&1 || :
 
 create() {
     n=$1
-- 
2.49.0

