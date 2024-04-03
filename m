Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56444145FFF
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712147385; cv=none; b=KsRSGEWyVdHOfKcKTXDX/ph1BhLsGGt5cAldP98FmbJtjDETRZjs1HYG5d8ZRqNcj8MA+gxllKDBxm3VFTWTXHw4/VQN3l2ptWat7oOx5EFtHZyLpi/TZAiolRD91fUKPDd5IFGIfd1uLaG7UuDdeGCjhpGHk7et/RTwrU2p9JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712147385; c=relaxed/simple;
	bh=d5B3Uwh5U0luQaWPosgN89PvRzuaNOZ0m6F7/sAhKoQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=V6XOQJoZYcTZvdB+KnUytA2KkWJpX7wf4hZ+5HIkFz9QrBdZpwgqU9Fr7tbfyThUQB7vAzMrZIdOUcVpwDEV4sZCIO/RE0PJpM6cU/NEhFFvC0r2RP2hF3YZEu9naaH6VwFeLfCT5tM/i7EDdj85RUZgWXIBpbMyq7ufMmt4r+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=XHdcoHta; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="XHdcoHta"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=09D+7sqKEoF4kMbKoWW0eMmbIY/Kpr1Q8HkwK1U+U20=; b=XHdcoHtaIflKMG0rMMvXQhQLvP
	mqnTNXWpwdIuNClZYjjoNrVTO96y210B2SzHa/D4v+xSBaAJoCRey3BfdVkoFJtLrGUKziSRC/ta9
	VdkveAlO/T42UTXsT7BAj6S/Lmd8p9xe9Xi2/6w5c9nef1kwmNiWvkd/yY8Yq+Tx7Rg8SmlkjsbmI
	X1bjsFbBt7UOP9nIMoEHFlxzkrWemh6oBTxCON2eljc4kA8yJ6V1NJ+uLBI9eJmOWmtdbDkX+MyXM
	bVC7NPbemyDg3j3HKHGhPPFuHsBFRHshxLm3JBc/8VkbhijaNHywGHxhAfGfUqMyVNxiwoPeS/vOu
	8oBQkRqA==;
Received: from [2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rrzRD-00HR7h-03
	for netfilter-devel@vger.kernel.org;
	Wed, 03 Apr 2024 13:09:55 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 0/2] Support for variables in map expressions
Date: Wed,  3 Apr 2024 13:09:35 +0100
Message-ID: <20240403120937.4061434-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The first patch replaces the current assertion failure for invalid
mapping expression in stateful-object statements with an error message.
This brings it in line with map statements.

It is possible to use a variable to initialize a map, which is then used
in a map statement, but if one tries to use the variable directly, nft
rejects it.  The second patch adds support for doing this.

Changes since v1

  * Patch 1 is new.
  * Patch 2 updated to add support for map variables in stateful object
    statements.

Jeremy Sowden (2):
  evaluate: handle invalid mapping expressions in stateful object
    statements gracefully.
  evaluate: add support for variables in map expressions

 src/evaluate.c                                |   7 +-
 .../shell/testcases/maps/0024named_objects_1  |  31 ++++
 .../shell/testcases/maps/anonymous_snat_map_1 |  16 ++
 .../maps/dumps/0024named_objects_1.json-nft   | 147 ++++++++++++++++++
 .../maps/dumps/0024named_objects_1.nft        |  23 +++
 .../maps/dumps/anonymous_snat_map_1.json-nft  |  58 +++++++
 .../maps/dumps/anonymous_snat_map_1.nft       |   5 +
 7 files changed, 285 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0024named_objects_1
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft

-- 
2.43.0

