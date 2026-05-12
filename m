Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7FC349CFF
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582030; cv=none; b=hn65ekyCDD4bcyAcouR423C0dTg4G37kTfN4nbaM8bhTlHwLfEYCmnJWg98hWrKnB92uLmp7rVBPSdku3AR5yM8R/zYkzJtIt0rvkPXhICdqyqlo5am0qgZxVvFk+Yk8Hom7T0ayEDJPiCihfpzmYb521hit+p6x3hA2lr1Cj8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582030; c=relaxed/simple;
	bh=baeiNKLJXcEyYn8j3NdvGFcfsucA+1RlvWo5/cuZM3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gB9O6E2smtwEQim9F2viLzWMkohtLdXFeYRHpBMemPJBh+w4iFa3hgmhUw0aJVRuNIcHa7w8VItOwVHdtPzjX5JEnUArwNiO/UhxNIx66pwSkrHzaRdHZ6nVQs/ekqiGOi9aq511sTfxneYWAZAHHurwyEg+njjxsYKoKqban8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XY75+3ZH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XY75+3ZH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C5C776026B;
	Tue, 12 May 2026 12:33:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778582019;
	bh=G3oad9yFsBXPLUx+m5bANRnxHKieiT0M0YAalGbztPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XY75+3ZH92P9HtHTLUK3n5r4B1FOLKWJNBTvuQkKNGcVGVMkH8cwllcykztymRPyw
	 hYq3WC+ZAdRDNYyxkPHIIGNSCYWZGginrtmlE9NSWV7/U6GzHpEmDDLTF6xqHezdyw
	 yIEqLmwezAfwNOe74o0rbGlASblRU/IuFFBHOtnwTH3KuKVW/vuV+7e4l9qkz6BlqL
	 rBjBORh+j7DwcArjiYWszp6nfPJtPLrodKoyYON1slHjyUeb1NOElkfF3WHlKPtdi4
	 cKymIK8NAXXSVrJ9ZFTcuoC6/GKme4sB/VWvdfGcaudCU79B+PGQ3fQ7qqVtGNxupX
	 enWJU3Qy3xQTw==
Date: Tue, 12 May 2026 12:33:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	stephane.ml.bryant@gmail.com, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: nf_queue: hold bridge skb->dev while
 queued
Message-ID: <agMCAScREzJjke_u@chamomile>
References: <cover.1778493188.git.royenheart@gmail.com>
 <ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KAoAqBGkwHgDqNjB"
Content-Disposition: inline
In-Reply-To: <ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com>


--KAoAqBGkwHgDqNjB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, May 12, 2026 at 03:57:25PM +0800, Ren Wei wrote:
> From: Haoze Xie <royenheart@gmail.com>
> 
> br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
> master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
> references on state.in/out and bridge physdevs, so a queued bridge
> packet can retain a freed bridge master in skb->dev until reinjection.
> 
> When the verdict is reinjected later, br_netif_receive_skb() re-enters
> the receive path with skb->dev still pointing at the freed bridge master,
> triggering a use-after-free.
> 
> Store skb->dev in the queue entry for bridge builds, hold a reference on
> it for the queue lifetime, and use the saved device when dropping queued
> packets during NETDEV_DOWN handling.
> 
> Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Tested-by: Haoze Xie <royenheart@gmail.com>
> Signed-off-by: Haoze Xie <royenheart@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  include/net/netfilter/nf_queue.h | 1 +
>  net/netfilter/nf_queue.c         | 5 +++++
>  net/netfilter/nfnetlink_queue.c  | 3 +++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index d17035d14d96..1e7eb8e85932 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -17,6 +17,7 @@ struct nf_queue_entry {
>  	unsigned int		id;
>  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	struct net_device	*skb_dev;

patch is not correct, this is only fixing it for br_netfilter.

>  	struct net_device	*physin;
>  	struct net_device	*physout;
>  #endif

Maybe normalize this special case with this patch instead? I will
propose it to the bridge maintainer.

It is strange that skb->dev != indev.

I have to take a second look, but I don't a usecase where skb->dev is
used in the netfilter tree can could break.

--KAoAqBGkwHgDqNjB
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 2cbae0f9ae1f..6f61e31f51f3 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -26,7 +26,11 @@
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	struct net_device *brdev = BR_INPUT_SKB_CB(skb)->brdev;
+
+	skb->dev = brdev;
 	br_drop_fake_rtable(skb);
+
 	return netif_receive_skb(skb);
 }
 
@@ -57,7 +61,6 @@ static int br_pass_frame_up(struct sk_buff *skb, bool promisc)
 	}
 
 	indev = skb->dev;
-	skb->dev = brdev;
 	skb = br_handle_vlan(br, NULL, vg, skb);
 	if (!skb)
 		return NET_RX_DROP;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84a180927eb7..ab1e180b5049 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -482,6 +482,7 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 			       struct net_bridge_vlan_group *vg,
 			       struct sk_buff *skb)
 {
+	struct net_device *brdev = BR_INPUT_SKB_CB(skb)->brdev;
 	struct pcpu_sw_netstats *stats;
 	struct net_bridge_vlan *v;
 	u16 vid;
@@ -502,7 +503,7 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 	 * pass the packet as is.
 	 */
 	if (!v || !br_vlan_should_use(v)) {
-		if ((br->dev->flags & IFF_PROMISC) && skb->dev == br->dev) {
+		if ((br->dev->flags & IFF_PROMISC) && brdev == br->dev) {
 			goto out;
 		} else {
 			kfree_skb(skb);

--KAoAqBGkwHgDqNjB--
