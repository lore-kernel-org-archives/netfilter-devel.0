Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A0B29B8D8
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753715; cv=none; b=YyexS+hJobvwrpSqWtoiYd7auwNTo4TyD8Obk0dwKDeolr2Ks6fTN4/rYnywdMXJj2YIjTqNkyULPmJnZ0nqN/Z9oloxcAZwGb/NnqfEWWdjXW3hKWSuFvB/kcI7v5aBEtQtXKDtOOGVYwhw9jUpIWrenHDNagdcZ5xOTCU9Utg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753715; c=relaxed/simple;
	bh=VzGrWgJiGSAB+cEzQGox8B/QrEIfOkTrUW0qMFNKgA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaJ+szeLZL9EWErYUgNCrdnuoxqh9lIrekMWXyf7UibGxXsHAOuxxtazeXrgMe3N6wiqu8lOV2zT/CIz7XHFo8kOc1k5l8LNH8qLS010dlX3iTF5R7ZpXi/HcKJ01JiHcTaDVb+0o+xknup8OpHaXE6FK9cxvyOQxdKdCbKk6c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=labj5BSA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W4ovxQAW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="labj5BSA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W4ovxQAW"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B0BC460290; Thu, 17 Jul 2025 14:01:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752753710;
	bh=SoEXp0dP7e0u0iX/XMAuADjJVKvSbAKaZGx8/d65130=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=labj5BSAWZkFqnbJ/KMifIM799Xp4A+yP4dBlHSfED7V3qNDxVvmFsU+5TQachyQ0
	 y574N9H3NOxio87hAAXy0czq7/NFGw1fYJ3Q+MkIwRsoeOmPK9vYDntb+fGynlUOYV
	 gvCzMV8MZvO+H10SVlVqSKi4huRahAbA3AVrEKtfMTsIoCjA0xFrrGmX3TaSyNVgh4
	 8j6rK59KexT+AksQwsheDqgrJu1PHLlXzCAnbzyZhs4687c3+RmUzRbOwjroDjXQnq
	 mdrjmct4qRXYCXSfjPdTIPf2mJpN7vyx07bfSBerDU4MfsJLQD/SnKE5yh159RVaP2
	 YVsjxnGMx0ymA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B56196028B;
	Thu, 17 Jul 2025 14:01:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752753709;
	bh=SoEXp0dP7e0u0iX/XMAuADjJVKvSbAKaZGx8/d65130=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W4ovxQAWBuMegBOVmxEEqumooYZbPT7iRiw16vnRYYUnHfaa1jhIShjWeyHAlN1FV
	 4dTbSc1iZTcL2iqU68TlifvAko/p+VqSc1ISBHhShAEsTKhkM0DqqAwTeUmLG2oHMo
	 RaTXuD18JOC44faucu1j55NQLLyN6UDz9LgjZOIrUke1W9Ox1yyYIrEF3jCUu719WP
	 hedOydK3Rx1mN6BxqaaS8Aw7CaI2uL400+xuW5xtsG1X+jlmYmHKd+3diTa4UrvyEp
	 L+j+NJVNKJVoXKbRH2vD6T7eiubpsM6ih49mYjeLYevyk3JYZbKeltMxlOSk29S1wX
	 bUy3KR566N5dw==
Date: Thu, 17 Jul 2025 14:01:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: shankerwangmiao@gmail.com
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aHjmETYGg4UtDdSf@lemonverbena>
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UooQY9lCHFAeNxOt"
Content-Disposition: inline
In-Reply-To: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>


--UooQY9lCHFAeNxOt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Jul 17, 2025 at 04:27:37PM +0800, Miao Wang via B4 Relay wrote:
> From: Miao Wang <shankerwangmiao@gmail.com>
> 
> The redirect target in ebtables do two things: 1. set skb->pkt_type to
> PACKET_HOST, and 2. set the destination mac address to the address of
> the receiving bridge device (when not used in BROUTING chain), or the
> receiving physical device (otherwise). However, the later cannot be
> implemented in nftables not given the translated mac address. So it is
> not appropriate to give a specious translation.

It should be possible to expose the bridge port device address through
this extension, see (untested) patch.

Then, it should be possible to provide this translation:

ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef \
        counter meta pkttype set host ether daddr set meta ibrhwdr accept'

--UooQY9lCHFAeNxOt
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="meta-hwaddr.patch"

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2beb30be2c5f..a0d9daa05a8f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -959,6 +959,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -999,6 +1000,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 5adced1e7d0c..d1ae1a2a59f5 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -59,6 +59,13 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		nft_reg_store_be16(dest, htons(p_proto));
 		return;
 	}
+	case NFT_META_BRI_IIFHWADDR:
+		br_dev = nft_meta_get_bridge(in);
+		if (!br_dev)
+			goto err;
+
+		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
+		return;
 	default:
 		return nft_meta_get_eval(expr, regs, pkt);
 	}
@@ -86,6 +93,9 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 	case NFT_META_BRI_IIFVPROTO:
 		len = sizeof(u16);
 		break;
+	case NFT_META_BRI_IIFHWADDR:
+		len = ETH_ALEN;
+		break;
 	default:
 		return nft_meta_get_init(ctx, expr, tb);
 	}

--UooQY9lCHFAeNxOt--
