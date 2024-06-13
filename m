Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DDC144D09;
	Thu, 13 Jun 2024 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279157; cv=none; b=KEK507E5sOVT3MODDq9u3T0Rva76WnedUVc3W+sOnzVEejBk174ch4OtlQk9dLUyHuHM3Kph6eVBhPjK+A1yEifkUbfU1lCVx/f7UKce2xDUHRVffopleNWTtvZLmfPC9TaUoLS8Vfxws4wwErkAf9IVvlbsCl84sEvipehbqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279157; c=relaxed/simple;
	bh=grdab82WPHAU2Bs/+idll0nUofOTiqg+iszwoJqy7J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIBVxiDfCZC3Lj6f1Hq4tYTi/XZSHOA8pARJgGaufsrrqv4YYZ/IQnJspkpK0fB1bDOzN/gcCB6aU8j/44SqNcchDsY/Pja+8RJ2hR4pKxpQ7WFD/NZhgLGAWSZ0jOmge+RPpktLBeXnhCAkyRyB/m52JiFN9MifG384UecAph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1or1/v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1or1/v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE221C2BBFC;
	Thu, 13 Jun 2024 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279157;
	bh=grdab82WPHAU2Bs/+idll0nUofOTiqg+iszwoJqy7J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1or1/v3WDT3RaAh/FVNgm0QwJ6AsLLJosPDKJOH+hfl3+URhuX3D5xv7BYwouXXI
	 FmevxM1dV+8pjHRJ6h72s3mabsEzEYBh4Sem4fX6po7XbHRLE4ZCSgvF94q+A2Ht8a
	 ssZ9m+C5402oTfE0z47EHe5YUtwza/Zg9JAZgYWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/213] netfilter: nf_tables: do not compare internal table flags on updates
Date: Thu, 13 Jun 2024 13:34:03 +0200
Message-ID: <20240613113235.498637940@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 4a0e7f2decbf9bd72461226f1f5f7dcc4b08f139 ]

Restore skipping transaction if table update does not modify flags.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -890,7 +890,7 @@ static int nf_tables_updtable(struct nft
 	if (flags & ~NFT_TABLE_F_DORMANT)
 		return -EINVAL;
 
-	if (flags == ctx->table->flags)
+	if (flags == (ctx->table->flags & NFT_TABLE_F_MASK))
 		return 0;
 
 	/* No dormant off/on/off/on games in single transaction */


