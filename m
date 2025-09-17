Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C166427B51C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141313; cv=none; b=W3hvo3SETLFooIuFcQK70K7JqlbmsnuEuNi+J5ne8xMeEEBhNbH9gXpJH1dCwMMV3uFxLbN/t7AOnETpH3gFYoeLzFdu+20BoMkl4HKXqeAk9CAVTEdW6+XVaxXJ6pMQUlPGSN58HVvLbqhs5ZUTNdpqLF2KxXnZTgb4/k0LIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141313; c=relaxed/simple;
	bh=DhQ3D7/HM8/Pu0R3X4LEcFAaX/XbsK73axrTdI+2x3I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=N04RNMNxVZO7k8JmY3YbgyhgScvRY938X3g1quWXiqWPaGDumyHSx4wg8lLj/62/1rWtLNqMWSEQtvNciURHRR+DUspC5ozT9vrIi+2us0QX1jARc84oMKbJuMKr6E2rA8HUFqo8bMe1daseXRTQDKWIFJn/+rpeRAppU4WlEDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=E9tGyEVE; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="E9tGyEVE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sri6lK3gK4hv6jqX8jSIbYM63fLRg8CzqjkqJX1Ruz8=; b=E9tGyEVEJ0bhUyAaGNe7r4SiFp
	x8CtA+iZ0gFgT/Sz2vKtrGj873as01/1Qky0I5FkE2sss1Sv7I1RDrfZgbJWl6rid6SctOPXHkQeT
	+su4Moj/b+nziyTbV/a2TEmpJ2yg8D5FhFsA80PGHyOv/dumV0ZRJL9z85n3NTHNUGQn3pi5TNN7p
	nA2fCTfFlN5obnmWv/mkvI3ZKhp3525ZdWy3f7M7kdZb+enp3T885QEP75GATnryDfwqulI5kH922
	3FjTNaeOHqVjMlk6HOJuV9cY8qgcVwr/OpcQKXocQ+BK7Pl2+HwQ2GuWzMw4lGkNdolaHAcfmm/Nz
	bvSt8y1Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1uyyrm-000000076ym-3ijh
	for netfilter-devel@vger.kernel.org;
	Wed, 17 Sep 2025 21:35:02 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/2] Service file installation fix
Date: Wed, 17 Sep 2025 21:34:52 +0100
Message-ID: <20250917203458.1469939-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The first patch contains corrections for some typo's.

Currently, if the systemd service file is not installed, the related man-page
and example nft file are still installed.  The second patch prevents this.

Jeremy Sowden (2):
  doc: fix some man-page mistakes
  build: don't install ancillary files without systemd service file

 Makefile.am                | 5 +++++
 configure.ac               | 1 +
 doc/nft.txt                | 2 +-
 doc/payload-expression.txt | 2 +-
 doc/statements.txt         | 2 +-
 5 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.51.0

