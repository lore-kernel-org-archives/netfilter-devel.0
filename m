Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DFC36AEC
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116219; cv=none; b=t1LgVmWZmUKI/8z5q4W46ffIZrASvWGkqhKazEOG3nWb0hKzvXR75zi2ELlC4topzfAoCx6y+AJpEXYMIr+CFPl1Z9HBuu27dMwyfOrM6JWuY/uQTOAelBP7FyFlf1NEVQrlchpgjNlkalI9MpUhvJg8UIzegem3dIoBWrT7zBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116219; c=relaxed/simple;
	bh=C4xshRsOIiGr2RwO/DeWI643jl9WN6HFaW6yJwIY38c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9AjhMrZL5rLZD6K5Y5PRq9YYgoKzRIbythMIkGOTg29etBt9ivJ0psGHgHtvPaniNYm5b40VUHn/7Qh6AmW0HJaAaG4JBzuBAaNm8h1nQjNejIRLePNc7YUTLigY8JcKZBDWLvsTcAbxaHA44nmhJWKZKSglKse/++JVfeMMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U8qVcI1e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U8qVcI1e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2LcsGz6DuShOudepC5OJ0NmQDx/np4tNRCR20emgKS8=; b=U8qVcI1exLbrI5EhouxfBKCX4A
	vjdMyflhA+TyDmu9fSFJtuQY58/AxN1fRmUhvEulGiE/pC2RhLQxnxmdPOduZDwg/cS79CIz7Vjy9
	15SANvgj0ovU5Tj0PsF7gZQlZUI//tGqjuRmcFNUjp8C0Ryo0+nYgZWwokGtvxoqXyA113yP+f3Zv
	Q+/1DClbwnQ4nWwimmCdzvKtCZEQ7l1D/JdVPIzk1XqLA/YiG53R+ITAYQ+BP1YqL1ndl3Hg5ImD5
	EPDJZNmF/KhOA9gEoJPhq+4ferKyRusqdfUpoL7y2GawpQK7UltmaUQ+BToW9YpnYUyoqPs7h5aen
	9EM3bQjA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5y-000000002UW-2kUp
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/14] nft: cmd: Init struct nft_cmd::head early
Date: Sat, 27 Jul 2024 23:36:39 +0200
Message-ID: <20240727213648.28761-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling nft_cmd_free() in error case segfaults otherwise if the to be
freed object is not part of a list yet.

Exposed by commit eab75ed36a4f2 ("nft: Avoid memleak in error path of
nft_cmd_new()"), but belongs to commit a7f1e208cdf9c (and may go well
along with it).

Fixes: a7f1e208cdf9c ("nft: split parsing from netlink commands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index b38da9bdc1c0b..58d5aa11e90d2 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -28,6 +28,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 	struct nft_cmd *cmd;
 
 	cmd = xtables_calloc(1, sizeof(struct nft_cmd));
+	INIT_LIST_HEAD(&cmd->head);
 	cmd->error.lineno = h->error.lineno;
 	cmd->command = command;
 	cmd->table = xtables_strdup(table);
-- 
2.43.0

