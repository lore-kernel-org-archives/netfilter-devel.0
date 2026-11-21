Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795305351;
	b=qdzfvgpxoXuZXR6xF3lmRuyY3WM5ifvpO1yma1Zpb8jSZXZ5c7/kMT2qxjaamn0OPpv0
	 L2Gjsr4WBfYF7+XuK9COCTvA1qwJiKPJyEJ9n3jbb/NsG0VLVwGLZDdgUcYUb79Zq3u8k
	 7SCpeUtgATw2XsWXON06TNZFRkzzBCwIBL4H2BwGEIAhkMITHyHu2hjfhKLTLF9dB804j
	 e1zM/V2hvZs/KKuEiPJQv1e1o8wBhtgWCXXGdkw6ywYailWCz53iNLjQJNl3oJ2gs1Noq
	 z9FMWewK5xOlmbxl7nqwyR2C1360lVWtkO3HgAZt6p1PQhx+rMQEQib38Ox7xZy6zbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795305351;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4pEJXLVs9bqHGwN/v3dYyLDeKkVuCcVeSSbouFxcT6I=;
	b=Y/zhxrNrEOjj9H48s7x71Uz6piSXoR93hBA0P4eDBWv2AWEa7YLNbypa+Q3NcB1dc6TW
	 qgGQHEG3Wj9okXcIAA70KPkucGeutKi0aCVaefDMQdWMQCLAogwXK+v6lw3rmvRa7VClP
	 Mx7T2Kfizg0wl8/Mf45mNv+MxNEwFC52pa92MVoyjEEUtvTAT4fceqMQWgmtTb4hd7hI+
	 4NG6gzZ6OLMERaCA5XMKbiLondFhGmdoqsTyfXqbEom9Fdwx1W/kPOkUKdLXyQQ6kormX
	 rPQX+S+oQFr3K8hbHZbWV8ziQ7DTTiUGLftaG02p4TRq7Soo2F4ryuhKcFdfnCJAopA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=x03BUjY5;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B4606A330
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 23:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 593B4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=x03BUjY5
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4395d31228so342164466b.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 15:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795305350; x=1795910150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pEJXLVs9bqHGwN/v3dYyLDeKkVuCcVeSSbouFxcT6I=;
        b=x03BUjY5uUk5kHPUWDQoJrha6rjwbkp4LWs7W69Bg8VCgkKrqio6101KiiOOutGiDs
         zt5oYt52Jqms6qGofc1L3RySoT1nGtc1JKj+T6QTBgxGiHIG+JG6dgkorSXxHb0FbM5c
         +MEcT9N0hJyRiLfkiMrafDBsG/VychsLAoVRv+rhH9U8/kPl0hruBpoppDI4oKxWXp96
         Mg5QgzF5lQA/wPf4E6lqLS7E3pMxI8NYJGwNZ5sYAoIKx3mf4gL0htLCyd4MlqqRPTG+
         eUvqBsDsSZz40MOKxdlokTMSO55CUG+IwLrvmGBDYOeS12ZuOPq4ci+2GtUJADxavSZH
         GqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795305350; x=1795910150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4pEJXLVs9bqHGwN/v3dYyLDeKkVuCcVeSSbouFxcT6I=;
        b=X92tDleuJYaSJpCVc/c2jMbIfhtAkMYriUDl5nbMXXqPB8x4cVXaCm/G9OUvw0U657
         xl8AJS/BllhnXySNqap22x8ASWuIZ5TOwQFr+XmwAtd9G/Vz46ru+s+P1d1LB0CHP79X
         fvOMLKWeLNJh9T4nsJJorpDrvT2VT4rj1nA6OwqbILjr7vCb6LDIicpT+qINOXFD5Q6k
         isaZ1Un3CPQWXqPy77Y5dzmm9ubeDlF+J4ns81TnyqK21fSHZmcqnPrEsx/MPVNL18uZ
         SOiVH6DMCgZLfVX4KX7p9nEDFBdC1vWUSHto5Q9NFX0NFkVjhs5AI7V3ATZpNQhj2ZF8
         HJpQ==
X-Gm-Message-State: APuU4Z8gRUNjhWYOsuhCJhTBMNFFtez7iEEYouUajkCir7kGUWDzcM8X
	Q+jEFZNncz7EEOzlTmA7sHBrKlrBKrI7/PSnuAzGrc5MI1NGU4r1+yf+gRepjS09vw==
X-Gm-Gg: AZFdTZfFbMml/xyGQ5MJjwGsQaJLG/XupzmnPy6ByMiDxfhOmC8jPG5AYTkEhFAMEe4
	JiSbDk5YUd4wILM4SpXDPcQ9YzDZ8kf2AHoVI6pjXOpACIWMt7HQ59RsgxIj3VD33M+rHz6S7oF
	yp1MLPK7hSVCDUGkAgs3XnoBezm1vDxi2FPZY7n2sXxtIykic84UAWRI9fRmExPHcw55Jsd6Zvv
	zsymqDCQyKp7hF3zNdx5KX6lIUbG0kbNVyAOmVywbBSPtXMK6MXILorGABzaGrF8ewwz7EG11Gg
	OwvTc7vwB00C59qMDYCsIpU0EMaidTQcFRrAaceikMdF29eN52M8HDQkUW2iOJm7iX5Qm6MsU/6
	oBHCxR3uhXNZfR8bXTw1Y3PrN1OvBmOD1AyXgPjszJcxm76lHjVuPZhPxEvAZ0u5YaYLP79GtQ3
	COT7dXNcvHr96RMFLlRiW8H2balAqhUFQBpnE5GgfZBAxhNDgfZ5v5vmY0mVIBsJc7l2ToW4XZ5
	kUIxb+KoaehFQXs9jQKKpLJsVGsa7feAeyt/nfHlMFeR+jZl4fcktHlj9cQKkZqy1rHSvM+/F5N
	DpgI/frnObjZppQRwGi2gbRXMNNsEQXQ0B75q2ZFONd6DnM7ZjP7afLwxX46I7q+9roXDhg+N4P
	Brb6pFNFP9tXqO4flSxWg56KPM1TK67bDBQpruIcUKlBTt+Sj8azZ9DDh338uCZBmePP186Qd1c
	B+LJrew5XFBf116sph0oc7oZb+y0ckumWonHQoYAFH4beZHanMj1ddjZUwGVcnXbuAwTGvgOZr/
	VmK+LI/QlIVPmScwWiPMSGwOiEqbuPkoNbS79+qtNnFT3ekF45MCyX1y8TtVHom7zqR/OT89esk
	Y63NSlVFLqscviNnCj+VJO4xs9SYQR+zd9AjpfTL2iswMU+fuJCllIL3Tdtp2Dlykgp+YS5wjAz
	6ECs9n0laxTInq7NVZPI=
X-Received: by 2002:a17:906:1983:b0:c51:268c:a129 with SMTP id a640c23a62f3a-c513a852063mr521092266b.25.1795305349757;
        Sat, 21 Nov 2026 15:55:49 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470f10000d28261fff0c406a.dip0.t-ipconnect.de. [2003:f2:470f:1000:d28:261f:ff0c:406a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae679e3sm247503266b.22.2026.11.21.15.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 15:55:48 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw address for XMIT_NEIGH type
Date: Sun, 22 Nov 2026 00:55:48 +0100
Message-ID: <20261121235548.2567423-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261120225227.3565643-2-pablo@netfilter.org>
References: <20261120225227.3565643-1-pablo@netfilter.org> <20261120225227.3565643-2-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Nov 20, 2026 at 11:52:26PM +0100, Pablo Neira Ayuso wrote:
> @@ -383,6 +400,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
>  	path->tun.dst = &rt->dst;
>  	path->dev = ctx->dev;
>  
> +	memcpy(ctx->daddr, ha, ETH_ALEN);
>  	ctx->dev = rt->dst.dev;

With this, an ipip or ip6tnl tunnel whose underlay device is a bridge
gets offloaded: br_fill_forward_path() finds the outer next hop's MAC
in the fdb and nft_dev_path_info() makes the tuple
FLOW_OFFLOAD_XMIT_DIRECT. On nf-next without the series such a flow is
not offloaded.

> +static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
> +{
[...]
> +	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH)
> +		return true;

For that direct tuple the gc returns here and never compares out.h_dest
with the neighbour entry. When the next hop behind the bridge changes its
MAC and the router's neighbour entry is replaced, the flow keeps sending
to the old MAC: IPIP and IP6IP6 over a bridge stall, 3 of 3 runs each
(QEMU, nf-next 994089a3fa38 with this series). IPIP over a plain port is
neigh xmit, is torn down and offloaded again, 3 of 3. A bridged direct
flow without a tunnel stalls the same way, here (3 of 3) and on nf-next
without the series (1 run).

Julius
