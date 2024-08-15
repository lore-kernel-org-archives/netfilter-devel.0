Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7719F49C;
	Thu, 15 Aug 2024 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730687; cv=none; b=sYh6n3qySP1VkET3NxPGCS7S+G7SI7bTKpReAmHXCem06c/L6/HrlyKPZMRWNg1it+7n9lT/QGToOUJicXMgHleM08SxOVXlPmshjRE5EUTTlD3LFBBTzHydlY/WKgrZLkHjDiSakQCcrEpjhHG53OSBCVnPYqvWzlxxYk/R3SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730687; c=relaxed/simple;
	bh=AsV4oErpSQF2rVODKV4dDokNSDEubvDJ1qNDOD5rgwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAQ5c9XKsa1E7GZpiICEeb2jjGBI59nCCdAygsbfLM0zk8HCJLckHlmEL1TbOJ6+qUytplSYE4ZujzSPNTXTmZxlkwsM6hiQoUVjpsA4KBDGvAut5IhLw/Z06aXUfxiX1q+YmOjpGqSZz5nVj+s2ekuBVdNwoBgd9Q+q2jYu5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ+QxUvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ+QxUvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A5FC32786;
	Thu, 15 Aug 2024 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730686;
	bh=AsV4oErpSQF2rVODKV4dDokNSDEubvDJ1qNDOD5rgwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ+QxUvkVzaELvK7LE+KT5auO0ndOdB2KglipYohd1vJ5VW1wpWQ7346VqGwwyafA
	 Hc+sV6LzScVlxS2FOY9JTCmReSKJVFeDJtAgG28z+8ye3hyPiKJ2BZIk8q4DNqGrNn
	 z8XcdDCRLie/Z5ZAeJXY0/nM0ggAJNtWVvKciHKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 466/484] netfilter: nf_tables: set element extended ACK reporting support
Date: Thu, 15 Aug 2024 15:25:24 +0200
Message-ID: <20240815131959.478016394@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b53c116642502b0c85ecef78bff4f826a7dd4145 upstream.

Report the element that causes problems via netlink extended ACK for set
element commands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5769,8 +5769,10 @@ static int nf_tables_getsetelem(struct s
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -6589,8 +6591,10 @@ static int nf_tables_newsetelem(struct s
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -6866,8 +6870,10 @@ static int nf_tables_delsetelem(struct s
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 	return err;
 }


