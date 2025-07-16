Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0D42F49F2
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669630; cv=none; b=ugRvmTWigWP+DrdgOMEvH7fRH3goo8Cc6jZQ9IAvOS0kMTAysTKm0IsRm9T/qxknRJ+efbiwsb4+lNMX2HwIGq0F0x5rNu99fWYjThtmF82fBfwdopTju3Nyjud3nuc7L/CZl1gekG8dtrHxUj806tQDuiv3x7ElxbHjp9+T1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669630; c=relaxed/simple;
	bh=L/C2/ygnIiOpNF/1t2WeLrIII+qTsp5oXoUF/PdCulM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNpsQgqmZWDloXXYlL+QkT233buRiV8AHkCSPYqAOVE3PR29/pAFQ8/DA0QfOXb21eyDoalHijUCx5YBWrwR03KDdajIy8pCZnqXoP4skmxqY5Q2hZ8bV7BLn870lxLhK2NduxIgoo/oUAB2UYD5Z7H3nNtQ4tsrJY+kRc56VD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gBgyxfRr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gBgyxfRr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o4sQ7sFD8hytjvWMlcSoDDV5hIfP1LBRc2EL8XUZRhI=; b=gBgyxfRrTEZblsysYV5BkNyI6L
	P0WacY3zzq1v+qaZSToJsIFRvCJe5PkrWumzQX+b9XNYsDa8upeFzss1zHqukLXnGt7+ISoPJeKDZ
	F9OPg3PL357AeZjvlSMsn9y+5FEAul3WRr8nkxDBwAOcLq1iHtaqitlGqMj+WG7KzH5RWsBnVWNQw
	3qNChIiDMBMpjXmR2SArNTUU20ZCC+NTkxuCKO5vMPu79/oHTGxC8ML2jzgkGQ6PPH4wkgpw3+hRF
	xrCGQr+hk3dNI+TB05a4nFYDJvooKQxWBpSEwlbaNLGKCvJnvl55x3LYEMCDKbUW/gaShG1yYP2hb
	c3DFqNUg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1Qw-0000000044D-3PeF;
	Wed, 16 Jul 2025 14:40:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 1/4] mnl: Call mnl_attr_nest_end() just once
Date: Wed, 16 Jul 2025 14:40:17 +0200
Message-ID: <20250716124020.5447-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250716124020.5447-1-phil@nwl.cc>
References: <20250716124020.5447-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling the function after each added nested attribute is harmless but
pointless.

Fixes: a66b5ad9540dd ("src: allow for updating devices on existing netdev chain")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 89bc742af3c5b..43229f2498e55 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -811,8 +811,8 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh, dev_array[i].location);
 			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
-			mnl_attr_nest_end(nlh, nest_dev);
 		}
+		mnl_attr_nest_end(nlh, nest_dev);
 	}
 	nft_dev_array_free(dev_array);
 }
-- 
2.49.0

