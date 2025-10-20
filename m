Received: from cow.ash.relay.mailchannels.net (cow.ash.relay.mailchannels.net [23.83.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B77B246762
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004311; cv=pass; b=jp3YdGf1JVXVO03wlM5CuY3zDe5RSJ+GhO0UILIbD/sGjbtY2WrNsDX2xuZUIbjKSBIeBOfZDeBFoaEQtL0ky8Ga9NO4VEh40mcihDQTDRVVTg8BQDB+eGF0D011ysnHT8Rsgl6MuqrQVSpiGZ9+KbULENE08hb5qCfLrlC/ncw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004311; c=relaxed/simple;
	bh=xPRUHv0Cnk/XNuV806VufV6gRYqZg9B+UR+dZERLZ9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sf+WuKIllIBWx1uF8PHfN2rYPowH5mbau0fn0fmb3OEVTffN6V02/1/jiqaB3SLjB2v/5CSivqhjI0uxYeND7yL5i8bAsnt5phcO29XSJZXTi77aOo337xL9r1MVKVIWzlWGTXTxVaMuVByRRVSq8NQMtlHVW5ovE+rTjCN2mnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 5A6F2942FD0;
	Mon, 20 Oct 2025 23:51:40 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-118-36-55.trex-nlb.outbound.svc.cluster.local [100.118.36.55])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6386994300A;
	Mon, 20 Oct 2025 23:51:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004296; a=rsa-sha256;
	cv=none;
	b=yG3oY2dPxz9S8xDjKc9XKBAIYYwfrNNiqwp76RbqWuMIIFpsPPDtB77OiQ6uIUiVGI0+4p
	vP+zr0ZZwhxrilOychPTnr6FDeSE/jXOCQOdO/9++sKSa1HIkanKtxx/djc8zpJMt8n5Cm
	raGvcv1ogqU6Cc7S//ZOvSx4dsiSVsmV1XnJ1Gi9bTXDmC3hQkWxhSp2ANsvplvGniQaXR
	OlO5ap3rTWI+yzn1Rz/jsTa4pAQ/hViY5OehLJGl8ot1a+Mhsiw9a0SJjXReJIywEFlW6w
	p7QoIWaPz3EHNjltJfMT7nSFawMKBqUeyVlAjCscthLaq+wT0gwQCWsk2J1KGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXd3CMWeDrl+nSWkVLvkA1W3/iMPGq9YgZ7uFssnT3Y=;
	b=t4XrYI3L9l/nUZEy3tuvB2Rv/sjNVg9S7HjumcqjK8PPIEG2rSZxcDQQkudzz5SPEtVtIA
	IIkZW2Iorr+FdkJx3LN1I2L3zqdyBPV0C0oNm/K24fGXaubyYKLhb5S+4nvrPQswWe4llG
	IQiuD9rjJYbcDgucFAK8Y92kkDVkGrozfHswyHLWCeVdZQwtQJqK5Nfb+dQF1qu6WpYCHH
	G5PrZloKHwE4KiO42v73gQmcSY45+wozAvi4OWd8dqywoe8RNmU3Yf71uJfL+VtbemqMJh
	iGf72Gukn5HSsXK3ErLTf1oImGrSdFZYq8lmRIDCD840RNPDUVM/KTM1zUsiPQ==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-rdvn2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Hook-Inform: 5a1ddf2d193076ff_1761004300256_2198978805
X-MC-Loop-Signature: 1761004300256:1016724204
X-MC-Ingress-Time: 1761004300256
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.36.55 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:40 +0000
Received: from [79.127.207.162] (port=40155 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAzf4-00000009col-1ZDS;
	Mon, 20 Oct 2025 23:51:33 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 6A1705A29C29; Tue, 21 Oct 2025 01:51:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v4 4/5] =?UTF-8?q?doc:=20describe=20include=E2=80=99s=20co?= =?UTF-8?q?llation=20order=20to=20be=20that=20of=20the=20C=20locale?=
Date: Tue, 21 Oct 2025 01:49:04 +0200
Message-ID: <20251020235130.361377-5-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Currently, `nft` doesn’t call `setlocale(3)` and thus `glob(3)` uses the `C`
locale.

Document this as it’s possibly relevant to the ordering of included rules.

This also makes the collation order “official” so any future localisation would
need to adhere to that.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 4ae998ed..3fd19c8d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -165,8 +165,8 @@ Include statements support the usual shell wildcard symbols (*,?,[]). Having no
 matches for an include statement is not an error, if wildcard symbols are used
 in the include statement. This allows having potentially empty include
 directories for statements like **include "/etc/firewall/rules/*"**. The wildcard
-matches are loaded in alphabetical order. Files beginning with dot (.) are not
-matched by include statements.
+matches are loaded in the collation order of the C locale. Files beginning with
+dot (.) are not matched by include statements.
 
 SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
-- 
2.51.0

