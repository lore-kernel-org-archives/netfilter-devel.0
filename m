Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFDB311977
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 05:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413742; cv=none; b=ARSRf4htt1misjgJx1huYqsRkq0Q0/nvOfD+4fdb25obhcaGGKbK6npx8qN5Kzvp/jT+7Y+FEmYEZB7Tudl04oQh7wtU7PvoqMSHyI9Ij1Cczy3CilJRYmjoY6/9Udt9beYVqiL6pVK4yC5lUZ8mVXVYafq6vaZbsJOj8ZIDw/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413742; c=relaxed/simple;
	bh=UopDtZD5K8kgb8dfUiL1X6TmtWCYzEo7JbUMg17hNMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NcbMOVMrLRvkcTb85Fc88a3JDaw7F6det+uqwd8Pt0dE3fFYXpzz2Zc2tXrucOlFsiFtwz8liTmhXCMvK2Omwp4E7VSm4aa+o5T90/kH9Zuvjqwfr1RdO6wLXGJOA9RnLY85zCdrrftKwfyZL74BwjvvFXAN4RrOJ5x2/5uvDTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=h9vJLWCq; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="h9vJLWCq"
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BE6633F8B8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 05:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1788413731;
	bh=dLYltDPCTeGY82+tHX4/+AymCvN+9iNUQhQg35BGKVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=h9vJLWCqa1YrZnYZC1ARvt1ZMl7FjkTK6l927yzkESnQcJ9x5HGI976AbeO6cVnzU
	 vVUSA/sKMeRnmLHNRedB/DEzNpNFy2hHIvQbQkVkIvjwR2bugJB18BPpKif3cEKOAA
	 aXNxFBEm5nPN3Mm8NA2+YxmihbsGAFtGI3KZktKklWodY5krK6xB/AJZiWqehia720
	 gSnt688cIFi07CaIfGkydbgMCXItrE9IXxGPIr7Ahx2p71LVkXaqAs4fud/6MCmHgO
	 Ths5O2g3ZPh8CDbcMHHxBvXZh9strGGcf41wauq8J/nbg5r7m633pw8N5VXntqwCKv
	 cbTUwFUUljUgbVQ+rGWB9wzUoI7DUZFug9MNd4qimAwO3z6Y4MQgizOt+ckwnE59FA
	 9lpJs4L0izpnPC7/TypCTEamO++MYWrvDdjbxefKCNNiNRW1urTkSI0v7crvkIEB+w
	 VQ+KvrsOaiGRclfsj5CtHx+HPaFdvo4sT4gjt1KGHGuyYlU9hxSYOeKewIpJUtRAWS
	 8xEq34XpS6aVNIlAFHIgpdPdoytIWY/DveelOnq1xWrrHi4nThYRWA54pDps+pKj7D
	 r9Nh/XfUOF8LenQs9ccUC4TQvxF4Q87EWW1mfOhJm/2I4/0bSgFa8SXjgr9xsXwvg/
	 5mV0i8tkQvflPqRfhCOA7Rtc=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d7293f13c6so26541415ad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 22:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788413730; x=1789018530;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dLYltDPCTeGY82+tHX4/+AymCvN+9iNUQhQg35BGKVA=;
        b=WcsfUTUiHweEvLF+MDzrZ1D5fOhlSVaisMExqqXVEmXi3XYBKUv/vznZ7+4kkWtXqE
         /3amurGAoEbNXZdDvb/yRqP1jcL0lqoouBDS4JjdwIJS6FPbko4rB1gJ6/wNVeTUuDcE
         Xp3PacZL+9UHCDeP3oEGog4Tc+0GXwT8hcX1MJ2bhjKR/D0xLE7aT6qWkrlOPNavt6KK
         /DywYHOP3IMN0vaF8BvdFLCv07ke9pI/vFbDGpQSjk9e3Hg1uNly3W/w37x/DEtdrhX/
         5bbiz9YuNkHc2CJP0WPuoLzxqCyRFZjpuEcBaoP2md+73QgQnrYQS0a3t9wH1/YNsqOK
         u6DA==
X-Forwarded-Encrypted: i=1; AKwUvBxrF8XSby6KyGxgStQfbsXEb9BDluSfRLa27EWJelJVBkDM3Sswh8pWe0oljCkhpYa26mQ3NZCM1+g0iavkvjg=@vger.kernel.org
X-Gm-Message-State: AFuF++lbXLkD3p8iIXGy5gEHFhPweYPDKwMm+Nd1PS/H0hcki52cnKOq
	aM5e/rOXoYjItd7evnzzsOVIqPbmv39KSP30Swm3oPo+Hs576dQqwsi9v1ULmrITlj/3aJUwghU
	ALxuu0Qm9sXm/2G77kVzppHfIZ9R35wiim00thTH+MJKKYOvTjkqxE3QxSgcgCKrBFAexroEn8O
	RUxgIdTKHf+w==
X-Gm-Gg: AYBFou0quzOsByDgQIBTwNMS8d9KKRXnp6Hljo1/193UjTdtGblLrqNbaEX5Ezlxcje
	zQmrP96mMuHDICW779oO6pAE6Z1qQm9I+pk8Q+lfIGzCWPxwxZUmTj+4O9qO4DLrfjQjSEQgt0r
	z09QfB/QLoPXsLLvvD8sRi8FcsQRRe5Q8y7uXNd3mBKMIggmbqGoeDD2u8kSn0Rn1mSabSM9LCN
	8dgAfpxl8xd9cwE/dWaE/68y+TAINOH8nLKD9kFPqjiO6Z/0uKrlebpJL1PAKw1k57yX76mpu3U
	iY1uZtLf2YdHj40znSBtqTgvo3HCyVpkH3YDuMrveQaAG6GiKVwTDTxxlVoOdTiamAn8pt8j9X8
	przhuryrj4PCOSE0=
X-Received: by 2002:a17:902:e80d:b0:2d5:2f49:b3f4 with SMTP id d9443c01a7336-2daec5f4369mr137279205ad.2.1788413730267;
        Wed, 02 Sep 2026 22:35:30 -0700 (PDT)
X-Received: by 2002:a17:902:e80d:b0:2d5:2f49:b3f4 with SMTP id d9443c01a7336-2daec5f4369mr137278155ad.2.1788413729531;
        Wed, 02 Sep 2026 22:35:29 -0700 (PDT)
Received: from [192.168.192.72] ([50.47.147.90])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2dafe0d062fsm4247405ad.5.2026.09.02.22.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 22:35:28 -0700 (PDT)
Message-ID: <dc652fbf-65d5-4772-b1c6-238be51cee5e@canonical.com>
Date: Wed, 2 Sep 2026 22:35:27 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] net, smack: Create a function to set secmarks
To: Casey Schaufler <casey@schaufler-ca.com>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, selinux@vger.kernel.org
References: <20260902220150.18586-1-casey@schaufler-ca.com>
 <20260902220150.18586-2-casey@schaufler-ca.com>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20260902220150.18586-2-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/26 15:01, Casey Schaufler wrote:
> Rather than open coding assignments to skb->secmark, use a helper function
> secxa_set_secmark(). This allows for a case where assigning a secmark
> is more complex than a simple assignment. The version of the function
> here does the legacy simple assignment.
> 
> Change the functions that currently assign values to skb->secmark to
> use this function.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

looks good

Reviewed-by: John Johansen <john.johansen@canonical.com>

> ---
>   include/linux/lsm_secxa.h        | 28 ++++++++++++++++++++++++++++
>   net/netfilter/nft_meta.c         |  5 +++--
>   net/netfilter/xt_CONNSECMARK.c   |  3 ++-
>   net/netfilter/xt_SECMARK.c       |  3 ++-
>   security/smack/smack_netfilter.c |  3 ++-
>   5 files changed, 37 insertions(+), 5 deletions(-)
>   create mode 100644 include/linux/lsm_secxa.h
> 
> diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
> new file mode 100644
> index 000000000000..926257d4730c
> --- /dev/null
> +++ b/include/linux/lsm_secxa.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (C) 2026 Casey Schaufler <casey@schaufler-ca.com>
> + */
> +
> +#ifndef __LINUX_LSM_SECXA_H
> +#define __LINUX_LSM_SECXA_H
> +
> +#ifdef CONFIG_NETWORK_SECMARK
> +
> +#include <linux/security.h>
> +#include <linux/skbuff.h>
> +
> +static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
> +{
> +	skb->secmark = secxa;
> +}
> +#else /* CONFIG_NETWORK_SECMARK */
> +
> +struct sk_buff;
> +
> +static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
> +{
> +}
> +#endif /* CONFIG_NETWORK_SECMARK */
> +
> +#endif  /* __LINUX_LSM_SECXA_H */
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 0a43e0787a68..bd0f7a0931f4 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -17,6 +17,7 @@
>   #include <linux/random.h>
>   #include <linux/smp.h>
>   #include <linux/static_key.h>
> +#include <linux/lsm_secxa.h>
>   #include <net/dst.h>
>   #include <net/ip.h>
>   #include <net/sock.h>
> @@ -502,7 +503,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
>   		break;
>   #ifdef CONFIG_NETWORK_SECMARK
>   	case NFT_META_SECMARK:
> -		skb->secmark = value;
> +		secxa_set_secmark(skb, value);
>   		break;
>   #endif
>   	default:
> @@ -950,7 +951,7 @@ static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
>   	const struct nft_secmark *priv = nft_obj_data(obj);
>   	struct sk_buff *skb = pkt->skb;
>   
> -	skb->secmark = priv->secid;
> +	secxa_set_secmark(skb, priv->secid);
>   }
>   
>   static int nft_secmark_obj_init(const struct nft_ctx *ctx,
> diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
> index 1494b3ee30e1..9d799d2459dc 100644
> --- a/net/netfilter/xt_CONNSECMARK.c
> +++ b/net/netfilter/xt_CONNSECMARK.c
> @@ -14,6 +14,7 @@
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   #include <linux/module.h>
>   #include <linux/skbuff.h>
> +#include <linux/lsm_secxa.h>
>   #include <linux/netfilter/x_tables.h>
>   #include <linux/netfilter/xt_CONNSECMARK.h>
>   #include <net/netfilter/nf_conntrack.h>
> @@ -55,7 +56,7 @@ static void secmark_restore(struct sk_buff *skb)
>   
>   		ct = nf_ct_get(skb, &ctinfo);
>   		if (ct && ct->secmark)
> -			skb->secmark = ct->secmark;
> +			secxa_set_secmark(skb, ct->secmark);
>   	}
>   }
>   
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index 5bc5ea505eb9..ea67aa92ddc2 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -11,6 +11,7 @@
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   #include <linux/module.h>
>   #include <linux/security.h>
> +#include <linux/lsm_secxa.h>
>   #include <linux/skbuff.h>
>   #include <linux/netfilter/x_tables.h>
>   #include <linux/netfilter/xt_SECMARK.h>
> @@ -36,7 +37,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
>   		BUG();
>   	}
>   
> -	skb->secmark = secmark;
> +	secxa_set_secmark(skb, secmark);
>   	return XT_CONTINUE;
>   }
>   
> diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
> index 17ba578b1308..b363c42f252e 100644
> --- a/security/smack/smack_netfilter.c
> +++ b/security/smack/smack_netfilter.c
> @@ -14,6 +14,7 @@
>   #include <linux/netfilter_ipv4.h>
>   #include <linux/netfilter_ipv6.h>
>   #include <linux/netdevice.h>
> +#include <linux/lsm_secxa.h>
>   #include <net/inet_sock.h>
>   #include <net/net_namespace.h>
>   #include "smack.h"
> @@ -29,7 +30,7 @@ static unsigned int smack_ip_output(void *priv,
>   	if (sk) {
>   		ssp = smack_sock(sk);
>   		skp = ssp->smk_out;
> -		skb->secmark = skp->smk_secid;
> +		secxa_set_secmark(skb, skp->smk_secid);
>   	}
>   
>   	return NF_ACCEPT;

