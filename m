Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175BF13F006
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2024 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421195; cv=none; b=oHajbk7PlaHqFxgiUNRdh/SnCgL35uKami4BOgyCstQ2VxUovitElq0kuJwPpQ3codHeKQRfJFXPK6eQ0Qoz6tQaxZvWhcDdJ5ZBcaMEmPyEHr4vc0eqQAiJWUPORon3RidhETMrSTZYpyJOaINeIcWxVnQb4cHH/+7+oQrhSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421195; c=relaxed/simple;
	bh=o0V5b/lqrk3IJthlla6ehnl4MTqtkr9NXXQrVNGOOI8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JHXKo2Me26SBpLbONbh9Hdz1p9L6P0oIxzFpOBfRvpE0IuNOjc2l1qreRW5j4/fBaDER2ki28zjS/Ar1wvdS+G0yVEmkD4nYFw97jk6vuHHRaa+0qETiVqnU4hRtksCUQYphQq8V3Fu+EafJ84ZkHOPtp2yfEeZ7y11XOx5Qkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=iajxSoM2; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="iajxSoM2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=47hSKzHTqSctVRCumxheMB+KTr2MUbpVfSmq0mD0OgY=; b=iajxSoM2PUIzBVPlJSNli8aHWD
	e8ggCOZs+zb+6KcLx+fNUznXgjFFCSj7L9YdP0pMx1mO+JVmtKR49Riiuigz1qDM1IBbgXene6ITh
	yKmG3G6CKoX4QJ1Tg0eEqhlApMjGFNqrPA3U9LIhopeEI4FbabywK+6/Rau4bxenz//u2YSF3encb
	48VIlzHDzOZEFDnz4Pkw/g46HFC1Dvs2C5MVh/TJEc/0a3FRZXvlJ+EqR77EqzgGs0m6q8xHRTedC
	sZUP2ciY1WKlZ92f9ffTO0g9d18sc/dYkM3Jdtfn29JrNXUns0iu3K35M4j7iSyG0mqY/Q2aHlGGT
	OsjCq53g==;
Received: from dreamlands.azazel.net ([81.187.231.252] helo=ulthar.dreamlands.azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1s1WfP-00G8U5-2M
	for netfilter-devel@vger.kernel.org;
	Mon, 29 Apr 2024 20:27:59 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 0/2] Support for variables in map expressions
Date: Mon, 29 Apr 2024 20:27:51 +0100
Message-ID: <20240429192756.1347369-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 81.187.231.252
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The first patch replaces the current assertion failure for invalid
mapping expression in stateful-object statements with an error message.
This brings it in line with map statements.

It is possible to use a variable to initialize a map, which is then used
in a map statement, but if one tries to use the variable directly, nft
rejects it.  The second patch adds support for doing this.

Changes since v2

  * Patch 2: error-checking (and test-cases) added for variables that do
    not contain maps

Changes since v1

  * Patch 1 is new.
  * Patch 2 updated to add support for map variables in stateful object
    statements.

Jeremy Sowden (2):
  evaluate: handle invalid mapping expressions in stateful object
    statements gracefully.
  evaluate: add support for variables in map expressions

 src/evaluate.c                                |  17 +-
 .../shell/testcases/maps/0024named_objects_1  |  31 ++++
 .../shell/testcases/maps/0024named_objects_2  |  23 +++
 .../shell/testcases/maps/anonymous_snat_map_1 |  16 ++
 .../shell/testcases/maps/anonymous_snat_map_2 |  23 +++
 .../maps/dumps/0024named_objects_1.json-nft   | 147 ++++++++++++++++++
 .../maps/dumps/0024named_objects_1.nft        |  23 +++
 .../maps/dumps/anonymous_snat_map_1.json-nft  |  58 +++++++
 .../maps/dumps/anonymous_snat_map_1.nft       |   5 +
 9 files changed, 341 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0024named_objects_1
 create mode 100755 tests/shell/testcases/maps/0024named_objects_2
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_2
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft

-- 
2.43.0

