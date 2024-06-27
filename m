Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B661CAB3
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719476309; cv=none; b=X0EuaeJw2zwHu65kNzfJClGLjucGQIeiIJ15QtxzGz48+0GlRCULj7VnB23bctrImszM7fN7Wanoq6NsPxXxmJUUKObEZrBNhTKu/DBWDivpk2iUfN279swcHmY5yn/xxfRh9n1KpMLcGVVoa50idveoeKTuEDdIOmlmGdnGCOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719476309; c=relaxed/simple;
	bh=xPKrTHUUB7BU7lc/BPWQzDDSXJNs7pkuWzpf7jbx5o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPLdvgB806ziJ2OA90jCk7GQ5wWkmdZUrBWELM8tv0YO6/qPgG3q1tWUCuWhrtv1zoeU6TyAS9ugj/+O1keGsVyJYXPT/n+dUFMkXlOodsbUiLDIZN5xfIKnO3cnp+hfFLAXtZi57MKc9a3Dx0CpBU2TN4cdg/qFNvH8wsVTpv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DKN1xNKJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DKN1xNKJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4SjhqU+1FpD7ybuaY5H8TvaravuYljGmjePsZSNZVRg=; b=DKN1xNKJV11DcEDyPE47qGZuUA
	BfYD7JLk3fanoZO/NVzBeq36OfsS8M918bu2GAx2RfWS22nK4zHO8Xf/RNNiD8pTL/QI/pzwxPDrR
	a30JTR3v1N6fJ1OWjRyUEt3SFBOZSWmCGAu+VZ0BzeA1GssNmrxWyyyL7Wd+AouYa0xAujgXkpOaP
	t8kvHqPZImsBkgOCoM7U5AUYEfPiFbwM8GjrOJNJ8sUt6X/DR6TWRJqveZZO2HH5pv9N1YQEQl3Sp
	78dEv8Yk53/JLvp6RC6EbgMLkRKH/nB5kS/E4ZHxSO7RWemmVGlgUEQa/BYj1j+6nrKhln/NaqKsr
	YvOb3qNg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMkKl-0000000080G-0Z55;
	Thu, 27 Jun 2024 10:18:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 2/3] lib: ipset: Avoid 'argv' array overstepping
Date: Thu, 27 Jun 2024 10:18:17 +0200
Message-ID: <20240627081818.16544-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240627081818.16544-1-phil@nwl.cc>
References: <20240627081818.16544-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The maximum accepted value for 'argc' is MAX_ARGS which matches 'argv'
array size. The maximum allowed array index is therefore argc-1.

This fix will leave items in argv non-NULL-terminated, so explicitly
NULL the formerly last entry after shifting.

Looks like a day-1 bug. Interestingly, this neither triggered ASAN nor
valgrind. Yet adding debug output printing argv entries being copied
did.

Fixes: 1e6e8bd9a62aa ("Third stage to ipset-5")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 lib/ipset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index c910d88805c28..3bf1c5fcdbc59 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -343,9 +343,9 @@ ipset_shift_argv(int *argc, char *argv[], int from)
 
 	assert(*argc >= from + 1);
 
-	for (i = from + 1; i <= *argc; i++)
+	for (i = from + 1; i < *argc; i++)
 		argv[i-1] = argv[i];
-	(*argc)--;
+	argv[--(*argc)] = NULL;
 	return;
 }
 
-- 
2.43.0

