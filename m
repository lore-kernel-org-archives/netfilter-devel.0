Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA04264F9E;
	Thu, 13 Mar 2025 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741859813; cv=none; b=ZF+X9CNb9SiawRp8CkUFqyuT03wXe6mEPUDhu26xW80C9jJsajGQECosHDlLGCmNj1CLL2khAtRU/fvFx87X6UXT7lHSnmkRJc4TBj6xHRifbxUTneKRzOrs9EIu5ajM8mu+7KYVZsJIsS6LaN80bvTbxXf/LxUWUaoKsOuMdok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741859813; c=relaxed/simple;
	bh=ID8InYM6vInNB3QiqZQq/uhymPx24SuVTTv+JMZ++3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s/eUbkeNhqw/GcXx2HV2n5ZJKZb6/PB2npUzTJz0HmH47JJlxtE3K5LWH2UuYc7qoRcFVMGRcS3ezgCayCp2GjTyYaDG4Z2z4isCiic7a5ztfmky9AhqVne62mkM89bQbQC4t9kPfFZsIyZVxG6lu2tX4sunjy0mNIOjlE4136A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gsqMEpn3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XIm0qxY1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gsqMEpn3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XIm0qxY1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 15962602B6; Thu, 13 Mar 2025 10:56:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859810;
	bh=87NRBYzNEbBX3v/RgvJXkxtoky5J9/I1wYHH6QMAE5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsqMEpn3Yijvw99Fzr+kodsjbxuFP5E+rHN0M/q0kIuWhZ/kejmVOH/Ye536al4oF
	 Fl0kQFXsUNUhaFLHlfsx4erfqV7KH2oAA5lMn1q/zIpBEtjFbpuwEwauiIpHn9DNGA
	 HLRgKfxlRf2kkKoYjGkuN7yEzte5k2gOX1xYyA5MK670Ajf+qBECx0HySaOU6CDol2
	 f/ygEKpuNwDmixDsfeXQAlnRtRwd5lyPQ1dNYCWWlSl+DfXoOOhksx8MjIwybmMz+M
	 Jphdcu/B3S1g52ZWgiP2UqiqNcZRtghVeXafjpfmg079h2ptxr1JkXg0Ix+uthlPog
	 gUoWwQqRBbVAQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B5400602B4;
	Thu, 13 Mar 2025 10:56:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859805;
	bh=87NRBYzNEbBX3v/RgvJXkxtoky5J9/I1wYHH6QMAE5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIm0qxY1MIm8Alqse4Lt1qHcK34Eie6M/O9qDQOwu2jPCXNh3rJopGb+K1nW5vR8Y
	 P2F+ZVT6gwe/968ForR4o9MoXQ2qCBuyiHMWkfXZpWBSqbSCw3K4UJiMnvuZcBmWZe
	 z0sAbgblkP0Rvo2ftE4nMbYxchEbgu0hpp//TDtGg9h5S8IEHfkLZjoA06ImL/Dwbi
	 wTVmK5U375AYxLRpSXhdGcCL7uwkm21yL18aAsCllAzfJ7M9evLduHY8q91MSUvcRQ
	 qKElMm+QYjnn5T/SISSAnXB0+YnXfztdw9HFyPvxTxTSJlDfG83J1qerbJfAQRmQv0
	 fTEGkLir1slkA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/4] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Thu, 13 Mar 2025 10:56:36 +0100
Message-Id: <20250313095636.2186-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250313095636.2186-1-pablo@netfilter.org>
References: <20250313095636.2186-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Kashavkin <akashavkin@gmail.com>

There is an incorrect calculation in the offset variable which causes
the nft_skb_copy_to_reg() function to always return -EFAULT. Adding the
start variable is redundant. In the __ip_options_compile() function the
correct offset is specified when finding the function. There is no need
to add the size of the iphdr structure to the offset.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Signed-off-by: Alexey Kashavkin <akashavkin@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index b8d03364566c..c74012c99125 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -85,7 +85,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
 	struct iphdr *iph, _iph;
-	unsigned int start;
 	bool found = false;
 	__be32 info;
 	int optlen;
@@ -93,7 +92,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
 		return -EBADMSG;
-	start = sizeof(struct iphdr);
 
 	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
 	if (optlen <= 0)
@@ -103,7 +101,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	/* Copy the options since __ip_options_compile() modifies
 	 * the options.
 	 */
-	if (skb_copy_bits(skb, start, opt->__data, optlen))
+	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
 		return -EBADMSG;
 	opt->optlen = optlen;
 
@@ -118,18 +116,18 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 		found = target == IPOPT_SSRR ? opt->is_strictroute :
 					       !opt->is_strictroute;
 		if (found)
-			*offset = opt->srr + start;
+			*offset = opt->srr;
 		break;
 	case IPOPT_RR:
 		if (!opt->rr)
 			break;
-		*offset = opt->rr + start;
+		*offset = opt->rr;
 		found = true;
 		break;
 	case IPOPT_RA:
 		if (!opt->router_alert)
 			break;
-		*offset = opt->router_alert + start;
+		*offset = opt->router_alert;
 		found = true;
 		break;
 	default:
-- 
2.30.2

