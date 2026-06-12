Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3E3DE434
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 12:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268150; cv=pass; b=E4dA5FdAolNrxqCHfwM2O4G6A7JKMs7h0aJCxIh83g0Wro4m/wwA/mP81sBPXf3THGTRm1pSVESlIMDUf92UZhRI7RKSzvkvdMD8cp4GXgK1eU8Ej8Zvyd0J6UUp7lLv6tnm4Dxy+uw/wFnjT2/UWze7GkiChWXi897alQ3CbX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268150; c=relaxed/simple;
	bh=REH0d3wYoIYM1ZfwUz5WWrrGIOX6hD42sKYZ0MI/c68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D2+FA72pqSkDqeU1xVCP0xnp2WAPof61+k7o2TrWiaIrdCfJ37Zva/FRIvDfN5lPBwUd7reF9Cj3OFaQ/JEDEvZ6I8GX+L5ASvYlg0eH3e8186upvXkFVs3/EB8Q6GB++fQrQgS40gXBIvJXFMZ2iCNms8+cRqzlX2mnCrjqVyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=Hv+PUnqi; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="Hv+PUnqi"
ARC-Seal: i=1; a=rsa-sha256; t=1781268118; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=LHIjTJguHlxgCeXYW1H+zHHaCSwyawwWNMTCuqI9lYfmC7tsCFUmdGJ5cRScmtDHfdZI/bsac9oVksfO6Fp5D3KLwmMausEaLxN3FoEoTjC6IC2mTNBo/NkOMhecZDIIfcSdAtdMNS04kuGkC87wF0k7ajrmlHPC0Mboj5gyuKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781268118; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0KL/XF/Vvi8vAhmaVj+NFnFKfoqpckK1aQ0xkfQQy4E=; 
	b=Ya2xtOZnJpoUGTuf9vTzHh3jUSN5WWCByXd3VFcmjLoeoswuCMDQ4RSN14oH1l+FgwUGaQ+MEz255Qsl8A0D8KbZR/Iic0yRf3LBMDAVDIrEZEFAvyp+vrcJTjs3mZRc0SuDUhaJbSj75pqgjtqKx6sTgrzb1Z9b45EkbcraZkk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781268118;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=0KL/XF/Vvi8vAhmaVj+NFnFKfoqpckK1aQ0xkfQQy4E=;
	b=Hv+PUnqi6GfQsT1hKzt1mEX8kR5j4JQB7oFhyqZw9t3N9o16bZ8EwtOCSLwEMeI8
	Jh6RAF1CwswNCiX5VQ8Y1x7oamk+OUdPZt/k5fJ7ZZPZjactLVzQGlJ1VhqOUcSy7Tu
	mW9YoN4mlOj3gb6a3oQvgZ2plqxC+T8dtcPXG6uI=
Received: by mx.zoho.eu with SMTPS id 1781268117581167.83152173815665;
	Fri, 12 Jun 2026 14:41:57 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Cc: Carlos Grillet <carlos@carlosgrillet.me>
Subject: [PATCH nf-next 2/6] netfilter: nf_nat_irc: replace u_int16_t with u16
Date: Fri, 12 Jun 2026 14:40:22 +0200
Message-ID: <20260612124027.71673-3-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int16_t with preferred kernel type u16

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/nf_nat_irc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 19c4fcc60c50..14b79cb0171b 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -39,7 +39,7 @@ static unsigned int help(struct sk_buff *skb,
 	char buffer[sizeof("4294967296 65635")];
 	struct nf_conn *ct = exp->master;
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 
 	/* Reply comes from server. */
 	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
-- 
2.54.0

