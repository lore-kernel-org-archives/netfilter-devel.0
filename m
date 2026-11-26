Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795653557;
	b=FYDRhCIvJiXhwbkYuABwZfOYHsT6IOw+UVDJ2aZNaZZbDz7UR7XFkklgRbY92HYlfCgO
	 t0S2dxJZt0JCc6aXlr8ICWRe+7mQKMyBZbjijzPgZxls6mGZ1pkdNN73m87sA3I0Bhwgg
	 P0+ZWz4O2+xp0yoXE3r/X5kd5Qw/Pv7Q6lpyZuFSRuMtJplSHJfwlStGUQKvOIPyIxQ+3
	 DN8j3wBxSxHj+uJFIwAjeFgGge5z7I4SDnUAd6rOHYmus2ysqlhb+9CDzwy6y3HkfaUmD
	 OX5ZNq5a3cZANtbykJCsLdIBA2ZdoaDcnNAie/+lOq9GAMwPS2m+agh0QqQFQDSkYlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795653557;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=bBlNwFZ+fNyTjA/Lofoe4aKT6dSVGZVRnabD6V+RQuY=;
	b=yvnQg/DATNsvpxkJWp3ke7Xu3RTF2DYn2yaonAI+k0X+/PLv+5SAy29fY/iitIgbNw4N
	 kZnZC67UKp8KNMZmuvidMfVf0pyBkD0AzzRxauSkW7fn8DIVICAZRBjV5evjaO72Bg2Dz
	 kp1bivAFhdg/RUW6K19YN76LH6Og6ENtBPWftDV7qQR6KZVldX4GksU9F6+NZBws28Kez
	 4v+xLhxxVYOZYAWCLUVyeiRsMoiQqHnoaNHuwsKwAssFlwzp9J6F1k08qeprcKDuOMFv9
	 w7VwbLuHjbKiHdqOQCpjuQvPdP/2enbjVZsuRo383eH9in3ZO+Kbo/7CD32ssbBeNWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bJRTvZO+;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C4B9B606A327;
	Thu, 26 Nov 2026 00:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4B9B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bJRTvZO+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795653554;
	bh=bBlNwFZ+fNyTjA/Lofoe4aKT6dSVGZVRnabD6V+RQuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bJRTvZO+FiUvEQuD5kWrZYayWtScEqIkGYdVpP0KBXifbRgzq78CU5DZT6Lz98C3m
	 DtSARt17IaXu5cFNfSZfmUsahmhhWmEMhUw6+omWPQMZ8ZA/mNSyuy7IoiYUpNzoNS
	 m1xaQvT0Lp4kA/0eNfMqHxfAVbmr/5xrGFhzywXxdBnuLNIKvv0H0/DobDewHG5DTS
	 SRbr4Qx2pzpDzNnCnWl7rlT3b4yPqIw6irU2jCuEcqCT5PheSyT3SZ1wWdM3ml40Gw
	 xVaHhzoNmbHkmpbYOjivDNCcdtCiWWvUPKlKjwBAoZ0LM5Hp0VhummGR8XRCJM2hLr
	 u7LcQBcAjvByA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1E38660081;
	Thu, 26 Nov 2026 01:39:14 +0100 (CET)
Date: Thu, 26 Nov 2026 01:39:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	co+85229ab197510ca7@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_exthdr: pull the IPv6 header before
 ipv6_find_hdr()
Message-ID: <awd_r2mOR7xuYzh4@chamomile>
References: <20261126001151.13793-1-xmei5@asu.edu>
 <awd9f47inahmDWRP@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VkGGqG0RUrhCu0NS"
Content-Disposition: inline
In-Reply-To: <awd9f47inahmDWRP@chamomile>


--VkGGqG0RUrhCu0NS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Nov 26, 2026 at 01:29:55AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 25, 2026 at 05:11:51PM -0700, Xiang Mei wrote:
[...]
> > Pull the header before the call, as act_ct, virtio_net_hdr_to_skb() and
> > nft_set_pktinfo_ipv6_ingress() already do.

I prefer this patch (see attachment).

Please, don't take, I will submit it myself including your
Reported-by: tag.

Thanks.

--VkGGqG0RUrhCu0NS
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="linearize-nh.patch"

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index e715405a73cb..5df31948c42d 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -21,14 +21,13 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 						  int nhoff)
 {
-	struct iphdr *iph, _iph;
 	u32 len, thoff, skb_len;
+	struct iphdr *iph;
 
-	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
-				 sizeof(*iph), &_iph);
-	if (!iph)
+	if (!pskb_may_pull(pkt->skb, sizeof(*iph)))
 		return -1;
 
+	iph = ip_hdr(pkt->skb);
 	if (iph->ihl < 5 || iph->version != 4)
 		return -1;
 
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index d7b8c559b795..06c0a57d54f0 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -30,17 +30,16 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt, int n
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
-	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = nhoff;
 	unsigned short frag_off;
+	struct ipv6hdr *ip6h;
 	u32 pkt_len, skb_len;
 	int protohdr;
 
-	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
-				  sizeof(*ip6h), &_ip6h);
-	if (!ip6h)
+	if (!pskb_may_pull(pkt->skb, sizeof(*ip6h)))
 		return -1;
 
+	ip6h = ipv6_hdr(pkt->skb);
 	if (ip6h->version != 6)
 		return -1;
 

--VkGGqG0RUrhCu0NS--
