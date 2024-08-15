Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2961AD40D;
	Thu, 15 Aug 2024 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732960; cv=none; b=NXYO/RfJZng5f9JjbG9iXCgZcyasKNLMhimzuGgKMZrg/cVeGxbfHs8Dv1ApxPMjIokbcqOJ7WLNbrF6Xm7YF/X4+R/qKgqu7FuFUUmpkgTnceowlg3BVz0kmdoO/55Yd5GCbe8x3f+lIYjg3pkDFindljW/p3WxrK0ZzdZHZXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732960; c=relaxed/simple;
	bh=eNXOjs886x9otbMu39lsA3vLfexaZam/zxH1BQPAtUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoliQyMPVb+kz4N3LJIb/k4e+b5bmh3GNFPRbTDqIytz9Qvx0zPLf3Q0y//kh9FlHPbUrpxXAWaKxbQKLRkJsyYX1vKrQV+kW3g3Oo7PMAMhRnSkn32lPAqL0V6p3ItQHCMcJe/ovy7t3K2NcMfr1zLe4UmkjCuz46JYF2LQORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu/z0IaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu/z0IaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B17C32786;
	Thu, 15 Aug 2024 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732960;
	bh=eNXOjs886x9otbMu39lsA3vLfexaZam/zxH1BQPAtUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xu/z0IaFSqiebuZgolu8Eyya1cYjwv4ST2uAXOmPIhrUxRa24+WqUBmV537H2xEYJ
	 YJuAGo1snK5Z1ceVwjja9eFInvzdBLl5e4871PnqYCjanfEX0OSUoPLXl2yrB4tLdD
	 RsCWUQEuJNN1frD6E1hLLwudlyF8Phekjdc1oThQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 339/352] netfilter: nf_tables: set element extended ACK reporting support
Date: Thu, 15 Aug 2024 15:26:45 +0200
Message-ID: <20240815131932.568000729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b53c116642502b0c85ecef78bff4f826a7dd4145 upstream.

Report the element that causes problems via netlink extended ACK for set
element commands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5354,8 +5354,10 @@ static int nf_tables_getsetelem(struct n
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -5848,8 +5850,10 @@ static int nf_tables_newsetelem(struct n
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -6058,9 +6062,10 @@ static int nf_tables_delsetelem(struct n
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
-
+		}
 		set->ndeact++;
 	}
 	return err;


