Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B631A3BB6;
	Thu, 15 Aug 2024 13:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729031; cv=none; b=kEH7i0JmX3Fudlhod92D4GmV0SC/pNVs8bUSo0Upxn0W1VVNdwncSQRXtklNMnoAZajLzCyZh4TmVQCqE6BC3rB1eWdNTT0HeXnkKmhS99kAErPAA4BxhRPMtY3J9xxlYYx01NEv6h//o5RwpiRo1+HQnnbInDMzzP3TA4V2T0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729031; c=relaxed/simple;
	bh=y8qxkunZoI625htJNPcVPTTG+8i7c80cN9+bww2gGIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLWLmnr8p4DgJxDClaV2LRH7EBQuWFTOZOogC9JwZKEVVNqv1/NvQ/NjVNITyzY+6ImegmWHRxKl77Eq8VB3ijCWqlMSmwfIg67IzchLtC58PGlCjSvxQFIu8UuaBKA4N1tPBKG4yNWQW2704SaxW+lyGZRstHq5NMfy2LQ3Z6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOnOF5l1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOnOF5l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7875DC4AF0A;
	Thu, 15 Aug 2024 13:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729030;
	bh=y8qxkunZoI625htJNPcVPTTG+8i7c80cN9+bww2gGIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOnOF5l11a5YVYV2tcdYXzA34ibNx5ByEGVl9LHuTgrQENamOl+TXvMe139b9eGIo
	 i2oNxp5OeeYkrSEeHXivwzt7h/uB5F2Xyd2pukpRD3FFRTUxj7XLxDSbjCjKU5HStp
	 DYxxyc4XcvxQEuJaZONUtfUE3E06yFtdnao3C/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 189/196] netfilter: nf_tables: set element extended ACK reporting support
Date: Thu, 15 Aug 2024 15:25:06 +0200
Message-ID: <20240815131859.302590027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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
@@ -4523,8 +4523,10 @@ static int nf_tables_getsetelem(struct n
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -4902,8 +4904,10 @@ static int nf_tables_newsetelem(struct n
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -5103,9 +5107,10 @@ static int nf_tables_delsetelem(struct n
 
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


