Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE27F41379F
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 07:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788420691; cv=none; b=OE772gscD+DBfW+QyFt2QGcKz1lawi9Mm2Bw+NeLkswBNk52zcNGXzlI+Ixw81s1Aa01XyUWHyIfh7pIEeLd2jaXznoF38lv9ENUp8bJHxrq1L1kSzumbVFZ+IRUKePPpuS6p6kmojnaHYK4zFkw80HYWM0VySK126LixyHq6AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788420691; c=relaxed/simple;
	bh=t/AKO0tLHF9dGW+FB6Zo8bC8blJ274t1qMusFIsWLAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iL6xhPcpETpo9usO7VkQO74vtiaTMi803PI05aRai9gOc/bokzRnrFF39pHOmYkt01nQOlKBN9xtjfZ3/6OEnZruYV++AEIHn9hzacumd4/oGU1fM350GrgyZDiEmbH+z0XedWtUeHEFMfJDLcImQMyLCwEo/kBLKzOxLZkj2cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=tDaaDydH; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="tDaaDydH"
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6C2BA4293A
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1788420681;
	bh=OwlZrVOYFz3WV0bGdbITbNQ4pLsWzVXi1TJiFeM+0OU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=tDaaDydHnkxrxMFkj7eJxKk4tzwJtyEpiqZYCyTUQYKazkI0cz0T63wfrVnkBSmIP
	 nr6RQTG1jPaCA88iMkKP3NN3/QdUStCdMrWmQJY+Ei1WwXdpxKyJGEI9m2t7ePInlG
	 +lsgPIahYiXtNkG4C3d7mJnielHjeKZWWFpvUkhG9jQpLTTC0chzplUSbgpxf2OJlG
	 X4Abw1Vr6vJcCsrfOdCPNfPHTDgvqHzSmGRigqm8QBGUUZnIBdpPVw7IHLvqPY1CjK
	 nDoV59f3DEgENw/HOX9/9+9Zdo4E6pFZ7MSP0enM/wHvuBi7QM2NrPr3BBjG8c3krN
	 WmoN7e7ybUEIjR0NAglWnB71oli45DvaDPpp5oR6c9akfEaHGVKqn5KNW2hLhA81W7
	 W15oY6RlV8zKG3Vy7I0fmo7dYYdplVQUOg4QDGp7sFpJzsm/ynZIF7HbJ/Tj4fRgWV
	 LnZEQh2KlP2l+bkWkl3pDGyfTsQF4/wM8txFaG8bRtK7tdtFL7ENZsGohaenS/0pH+
	 DjNB8+3z04d6EuR2p/+6yDEGl9QVB2Fvr+cqO0NlUXtO1V/FX3wymenRT+jU+UPO/U
	 lQQQ1vHSm4yX0ywAN8W2Di8QiEErZUPelaWKNLa5EPp/bxv0FEJRmLJPioJH0N/umw
	 k6m+N9/BlGweF1tL3/qZQ/5Y=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cec4226c70so24894955ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 00:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788420680; x=1789025480;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OwlZrVOYFz3WV0bGdbITbNQ4pLsWzVXi1TJiFeM+0OU=;
        b=Vz7oYOp6pl7IC1lCMNX1800/kl/S73skKtUCwYYUSOBO0CrVE0H4TrTzf7b2VS9Qnb
         lyrsT4hrle7T5UQ3mMcFNJOcBMOVkT45oS7kSgp1r/SfJ4k47t++OvMqmxCwHKYBlNus
         bqa+occ6V9mFMG9iZEoASJy9z47ImFk8tdq8mz1FEs8h0AIZDVEOqPT7s7qDGPOxRJq8
         ONflWlhDA1CIToaw78abnlzrgOJDL+8efLgYmvNKRRie6FQc2PdF6dEUziMF80/PbdAH
         H8FB99Qfgk/EdUFlBf1/QBYLcEp9sKVf5BnPO+R9tWJRmiFStc+EQghQcxxYKvkgsYIf
         m6Ig==
X-Forwarded-Encrypted: i=1; AKwUvBww6ppjsttyQqtQUkyNdbP/I0PTV53otL9Jv3RaUn5GhbhTdkLrV1ZtjMAUcUdp2mGxWmhPPhh0zWsnIuwOkzE=@vger.kernel.org
X-Gm-Message-State: AFuF++nPJJXScFZb8ookdQ0A58UDWdTNmItID4WD6d1+MHxo6Qvtzk3s
	wBO1Y/7Hfv0RR8HzmXro3mBdVn+nXV7s1j+f8vAb909qNSJlUbm8ao4WDNLpp8QI5rSEjgZFxS/
	koPsHJ+fQiDVHfMww1zUnCDZ/ZbnWBs7lcXsGn4IdhugQ+V4KX3LXeS0w4WKakhuVcGCzx6FvKq
	riGf60fwTwIQ==
X-Gm-Gg: AYBFou3ads1zPXJEWNpHR1isI7s8bs/jET9uhaFmABnEiAyAkf0G2XiKIcP/tl7hsNE
	PHxXBN1eDGuK7ZN7g/IT7zFy9g597m79OK7EmpuHPZgL764R7F4I2uJLuJWq/3rDUERxNz3aNnn
	TR/xNaxIMcZr+fin5o0ZDVc5uuY5s/CI3DWOMShFp9bEpEolckUBi10ENdSscSbLRQSk8bpD7d7
	eVqVBOc/Y+dxc+qwQUgYp6BwyW/WDY9CruG+an1fMEhhtarea66k7w+DYvHiw88638FuPnfSbq0
	HxgBPfpUaNl5WkeiT6Gm5ocZICQ1PGevHmcj57EUP1Qk/t7nA1Qyv4qhKlDVlLD7EbuTc808XAk
	lJ7q82UIqPl2dgFQ=
X-Received: by 2002:a17:902:fc47:b0:2d9:33d4:a910 with SMTP id d9443c01a7336-2daec5f55a5mr153173095ad.4.1788420679687;
        Thu, 03 Sep 2026 00:31:19 -0700 (PDT)
X-Received: by 2002:a17:902:fc47:b0:2d9:33d4:a910 with SMTP id d9443c01a7336-2daec5f55a5mr153172425ad.4.1788420679114;
        Thu, 03 Sep 2026 00:31:19 -0700 (PDT)
Received: from [192.168.192.72] ([50.47.147.90])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2dafed49b93sm5727745ad.67.2026.09.03.00.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 00:31:18 -0700 (PDT)
Message-ID: <6965738d-75a6-4da6-8dba-6214d3e6a458@canonical.com>
Date: Thu, 3 Sep 2026 00:31:17 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] net, lsm: Change skb secmarks to x-array indexes
To: Casey Schaufler <casey@schaufler-ca.com>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, selinux@vger.kernel.org
References: <20260902220150.18586-1-casey@schaufler-ca.com>
 <20260902220150.18586-8-casey@schaufler-ca.com>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20260902220150.18586-8-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/26 15:01, Casey Schaufler wrote:
> Maintain a xarray of lsm_prop structures which represent the
> LSM security information passed via skb->secmark. Pass the xarray
> index of the appropriate lsm_prop (the secxa) instead of an LSM
> specific secid. Allow multiple LSMs to specify their components
> in xarray entries, or create new entries as necessary.
> 
> Change uses of security_secctx_to_secid() to security_secctx_to_lsmprop()
> in the netfilter and iptables code. Change security_secmark_relabel_packet()
> to accept an lsm_prop pointer rather than a secid. Change secxa_set_secmark()
> to update and create new entries as necessary.
> 
> Update the SELinux, Smack and AppArmor hooks that use secmarks to
> expect a secxa xarray index instead of a secid.
> 

see comments below

> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>   include/linux/lsm_hook_defs.h    |  2 +-
>   include/linux/lsm_secxa.h        |  2 +
>   include/linux/security.h         |  4 +-
>   net/netfilter/nfnetlink_queue.c  | 12 +++++-
>   net/netfilter/nft_meta.c         | 15 ++++---
>   net/netfilter/xt_SECMARK.c       | 16 +++++--
>   security/apparmor/net.c          |  8 +++-
>   security/lsm_secxa.c             | 20 ++++++
>   security/security.c              |  6 +--
>   security/selinux/hooks.c         | 71 +++++++++++++++++++++++++++-----
>   security/smack/smack_lsm.c       | 10 ++++-
>   security/smack/smack_netfilter.c | 10 +++--
>   12 files changed, 141 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 679c40a8e127..8ecf07e0e3f0 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -371,7 +371,7 @@ LSM_HOOK(void, LSM_RET_VOID, inet_csk_clone, struct sock *newsk,
>   	 const struct request_sock *req)
>   LSM_HOOK(void, LSM_RET_VOID, inet_conn_established, struct sock *sk,
>   	 struct sk_buff *skb)
> -LSM_HOOK(int, 0, secmark_relabel_packet, u32 secid)
> +LSM_HOOK(int, 0, secmark_relabel_packet, struct lsm_prop *prop)
>   LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_inc, void)
>   LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_dec, void)
>   LSM_HOOK(void, LSM_RET_VOID, req_classify_flow, const struct request_sock *req,
> diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
> index 84b06c093460..5be9d64e67e4 100644
> --- a/include/linux/lsm_secxa.h
> +++ b/include/linux/lsm_secxa.h
> @@ -7,6 +7,8 @@
>   #ifndef __LINUX_LSM_SECXA_H
>   #define __LINUX_LSM_SECXA_H
>   
> +#include <linux/types.h>
> +
>   #ifdef CONFIG_SECURITY
>   
>   struct lsm_prop;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 19adc19eb9af..ffbd1708065f 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1715,7 +1715,7 @@ void security_inet_csk_clone(struct sock *newsk,
>   			const struct request_sock *req);
>   void security_inet_conn_established(struct sock *sk,
>   			struct sk_buff *skb);
> -int security_secmark_relabel_packet(u32 secid);
> +int security_secmark_relabel_packet(struct lsm_prop *prop);
>   void security_secmark_refcount_inc(void);
>   void security_secmark_refcount_dec(void);
>   int security_tun_dev_alloc_security(void **security);
> @@ -1898,7 +1898,7 @@ static inline void security_inet_conn_established(struct sock *sk,
>   {
>   }
>   
> -static inline int security_secmark_relabel_packet(u32 secid)
> +static inline int security_secmark_relabel_packet(struct lsm_prop *prop)
>   {
>   	return 0;
>   }
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index b8aaf39cb4d8..ebab037edc6b 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -32,6 +32,7 @@
>   #include <linux/cgroup-defs.h>
>   #include <linux/rhashtable.h>
>   #include <linux/jhash.h>
> +#include <linux/lsm_secxa.h>
>   #include <net/gso.h>
>   #include <net/sock.h>
>   #include <net/tcp_states.h>
> @@ -606,8 +607,15 @@ static int nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
>   {
>   	int seclen = 0;
>   #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
> -	if (skb->secmark)
> -		seclen = security_secid_to_secctx(skb->secmark, ctx);
> +	struct lsm_prop *prop;
> +	int rc;
> +
> +	if (skb->secmark) {
> +		rc = secxa_get_lsmprop(&prop, skb->secmark);
> +		if (rc)
> +			return 0;
> +		seclen = security_lsmprop_to_secctx(prop, ctx, LSM_ID_UNDEF);
> +	}
>   #endif
>   	return seclen;
>   }
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index bd0f7a0931f4..664191dfa4b2 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -927,21 +927,24 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
>   
>   static int nft_secmark_compute_secid(struct nft_secmark *priv)
>   {
> -	u32 tmp_secid = 0;
> +	struct lsm_prop tmp_prop;
> +	u32 secxa = 0;
>   	int err;
>   
> -	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
> +	err = security_secctx_to_lsmprop(priv->ctx, strlen(priv->ctx),
> +					 &tmp_prop, LSM_ID_UNDEF);
>   	if (err)
>   		return err;
>   
> -	if (!tmp_secid)
> -		return -ENOENT;
> +	err = secxa_from_lsmprop(&tmp_prop, &secxa);
> +	if (err)
> +		return err;
>   
> -	err = security_secmark_relabel_packet(tmp_secid);
> +	err = security_secmark_relabel_packet(&tmp_prop);
>   	if (err)
>   		return err;
>   
> -	priv->secid = tmp_secid;
> +	priv->secid = secxa;
>   	return 0;
>   }
>   
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index ea67aa92ddc2..05b023a7c576 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -43,13 +43,15 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
>   
>   static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
>   {
> +	struct lsm_prop prop;
>   	int err;
>   
>   	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
>   	info->secid = 0;
>   
> -	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
> -				       &info->secid);
> +	err = security_secctx_to_lsmprop(info->secctx, strlen(info->secctx),
> +					 &prop, LSM_ID_UNDEF);
> +
>   	if (err) {
>   		if (err == -EINVAL)
>   			pr_info_ratelimited("invalid security context \'%s\'\n",
> @@ -57,18 +59,24 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
>   		return err;
>   	}
>   
> -	if (!info->secid) {
> +	if (!lsmprop_is_set(&prop)) {
>   		pr_info_ratelimited("unable to map security context \'%s\'\n",
>   				    info->secctx);
>   		return -ENOENT;
>   	}
>   
> -	err = security_secmark_relabel_packet(info->secid);
> +	err = security_secmark_relabel_packet(&prop);
>   	if (err) {
>   		pr_info_ratelimited("unable to obtain relabeling permission\n");
>   		return err;
>   	}
>   
> +	err = secxa_from_lsmprop(&prop, &info->secid);
> +	if (err) {
> +		pr_info_ratelimited("unable to obtain secmark\n");
> +		return err;
> +	}
> +
>   	security_secmark_refcount_inc();
>   	return 0;
>   }
> diff --git a/security/apparmor/net.c b/security/apparmor/net.c
> index cf590dd08540..e26e15c2d947 100644
> --- a/security/apparmor/net.c
> +++ b/security/apparmor/net.c
> @@ -8,6 +8,7 @@
>    * Copyright 2009-2017 Canonical Ltd.
>    */
>   
> +#include <linux/lsm_secxa.h>
>   #include "include/af_unix.h"
>   #include "include/apparmor.h"
>   #include "include/audit.h"
> @@ -365,12 +366,17 @@ static int aa_secmark_perm(struct aa_profile *profile, u32 request, u32 secid,
>   			   struct apparmor_audit_data *ad)
>   {
>   	int i, ret;
> +	struct lsm_prop *prop;
>   	struct aa_perms perms = { };
>   	struct aa_ruleset *rules = profile->label.rules[0];
>   
>   	if (rules->secmark_count == 0)
>   		return 0;
>   
> +	ret = secxa_get_lsmprop(&prop, secid);
> +	if (ret)
> +		return ret;
> +
>   	for (i = 0; i < rules->secmark_count; i++) {
>   		if (!rules->secmark[i].secid) {
>   			ret = apparmor_secmark_init(&rules->secmark[i]);
> @@ -378,7 +384,7 @@ static int aa_secmark_perm(struct aa_profile *profile, u32 request, u32 secid,
>   				return ret;
>   		}
>   
> -		if (rules->secmark[i].secid == secid ||
> +		if (rules->secmark[i].secid == prop->apparmor.label->secid ||
>   		    rules->secmark[i].secid == AA_SECID_WILDCARD) {
>   			if (rules->secmark[i].deny)
>   				perms.deny = ALL_PERMS_MASK;
> diff --git a/security/lsm_secxa.c b/security/lsm_secxa.c
> index ccbe78095d70..f0702ac5601d 100644
> --- a/security/lsm_secxa.c
> +++ b/security/lsm_secxa.c
> @@ -103,7 +103,25 @@ EXPORT_SYMBOL(secxa_from_lsmprop);
>    */
>   void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
>   {
> -	if (!skb->secmark)
> +	struct lsm_prop *olp;
> +	struct lsm_prop *nlp;
> +	struct lsm_prop prop;
> +	u32 tsecxa;
> +	int rc;
> +
> +	if (!skb->secmark) {
>   		skb->secmark = secxa;
> +		return;
> +	}
> +
> +	olp = xa_load(&secxa_xa, skb->secmark);
> +	nlp = xa_load(&secxa_xa, secxa);
> +
> +	prop = *olp;
> +	security_update_lsmprop(&prop, nlp, LSM_ID_UNDEF);
> +
> +	rc = secxa_from_lsmprop(&prop, &tsecxa);
> +	if (!rc)
> +		skb->secmark = tsecxa;
>   }
>   EXPORT_SYMBOL(secxa_set_secmark);
> diff --git a/security/security.c b/security/security.c
> index 1dec0037370b..e80e7823ce14 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -4646,15 +4646,15 @@ EXPORT_SYMBOL(security_inet_conn_established);
>   
>   /**
>    * security_secmark_relabel_packet() - Check if setting a secmark is allowed
> - * @secid: new secmark value
> + * @lsmprop: new secmark value
>    *
>    * Check if the process should be allowed to relabel packets to @secid.
change @secid to @lsmprop

>    *
>    * Return: Returns 0 if permission is granted.
>    */
> -int security_secmark_relabel_packet(u32 secid)
> +int security_secmark_relabel_packet(struct lsm_prop *prop)
>   {
> -	return call_int_hook(secmark_relabel_packet, secid);
> +	return call_int_hook(secmark_relabel_packet, prop);
>   }
>   EXPORT_SYMBOL(security_secmark_relabel_packet);
>   
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 12614478b638..bf832eff0b92 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -94,6 +94,7 @@
>   #include <linux/io_uring/cmd.h>
>   #include <uapi/linux/lsm.h>
>   #include <linux/memfd.h>
> +#include <linux/lsm_secxa.h>
>   
>   #include "initcalls.h"
>   #include "avc.h"
> @@ -5414,7 +5415,16 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
>   		return err;
>   
>   	if (selinux_secmark_enabled()) {
> -		err = avc_has_perm(sk_sid, skb->secmark, SECCLASS_PACKET,
> +		struct lsm_prop *prop;
> +		u32 secmark = 0;
> +
> +		if (skb->secmark) {
> +			err = secxa_get_lsmprop(&prop, skb->secmark);
> +			if (!err)
> +				secmark = prop->selinux.secid;
> +		}
> +
> +		err = avc_has_perm(sk_sid, secmark, SECCLASS_PACKET,
>   				   PACKET__RECV, &ad);
>   		if (err)
>   			return err;
> @@ -5483,7 +5493,15 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>   	}
>   
>   	if (secmark_active) {
> -		err = avc_has_perm(sk_sid, skb->secmark, SECCLASS_PACKET,
> +		struct lsm_prop *prop;
> +		u32 secmark = 0;
> +
> +		if (skb->secmark) {
> +			err = secxa_get_lsmprop(&prop, skb->secmark);
> +			if (!err)
> +				secmark = prop->selinux.secid;
> +		}
> +		err = avc_has_perm(sk_sid, secmark, SECCLASS_PACKET,
>   				   PACKET__RECV, &ad);
>   		if (err)
>   			return err;
> @@ -5885,10 +5903,10 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
>   	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
>   }
>   
> -static int selinux_secmark_relabel_packet(u32 sid)
> +static int selinux_secmark_relabel_packet(struct lsm_prop *lsmprop)
>   {
> -	return avc_has_perm(current_sid(), sid, SECCLASS_PACKET, PACKET__RELABELTO,
> -			    NULL);
> +	return avc_has_perm(current_sid(), lsmprop->selinux.secid,
> +			    SECCLASS_PACKET, PACKET__RELABELTO, NULL);
>   }
>   
>   static void selinux_secmark_refcount_inc(void)
> @@ -6016,10 +6034,21 @@ static unsigned int selinux_ip_forward(void *priv, struct sk_buff *skb,
>   		}
>   	}
>   
> -	if (secmark_active)
> -		if (avc_has_perm(peer_sid, skb->secmark,
> +	if (secmark_active) {
> +		struct lsm_prop *prop;
> +		u32 secmark = 0;
> +		int err;
> +
> +		if (skb->secmark) {
> +			err = secxa_get_lsmprop(&prop, skb->secmark);
> +			if (!err)
> +				secmark = prop->selinux.secid;
> +		}
> +
> +		if (avc_has_perm(peer_sid, secmark,
>   				 SECCLASS_PACKET, PACKET__FORWARD_IN, &ad))
>   			return NF_DROP;
> +	}
>   
>   	if (netlbl_enabled())
>   		/* we do this in the FORWARD path and not the POST_ROUTING
> @@ -6093,10 +6122,20 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
>   	if (selinux_parse_skb(skb, &ad, NULL, 0, &proto))
>   		return NF_DROP;
>   
> -	if (selinux_secmark_enabled())
> -		if (avc_has_perm(sksec->sid, skb->secmark,
> +	if (selinux_secmark_enabled()) {
> +		struct lsm_prop *prop;
> +		u32 secmark = 0;
> +		int err;
> +
> +		if (skb->secmark) {
> +			err = secxa_get_lsmprop(&prop, skb->secmark);
> +			if (!err)
> +				secmark = prop->selinux.secid;
> +		}
> +		if (avc_has_perm(sksec->sid, secmark,
>   				 SECCLASS_PACKET, PACKET__SEND, &ad))
>   			return NF_DROP_ERR(-ECONNREFUSED);
> +	}
>   
>   	if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
>   		return NF_DROP_ERR(-ECONNREFUSED);
> @@ -6215,10 +6254,20 @@ static unsigned int selinux_ip_postroute(void *priv,
>   	if (selinux_parse_skb(skb, &ad, &addrp, 0, NULL))
>   		return NF_DROP;
>   
> -	if (secmark_active)
> -		if (avc_has_perm(peer_sid, skb->secmark,
> +	if (secmark_active) {
> +		struct lsm_prop *prop;
> +		u32 secmark = 0;
> +		int err;
> +
> +		if (skb->secmark) {
> +			err = secxa_get_lsmprop(&prop, skb->secmark);
> +			if (!err)
> +				secmark = prop->selinux.secid;
> +		}
> +		if (avc_has_perm(peer_sid, secmark,
>   				 SECCLASS_PACKET, secmark_perm, &ad))
>   			return NF_DROP_ERR(-ECONNREFUSED);
> +	}


doesn't

   selinux_socket_getpeersec_dgram()
   selinux_req_classify_flow()

I haven't detangled yet whether the xfrm hooks, every grab the
secmark of a packet directly. It looks to me so far to be only
the skb->xfrm->security->ctx_sid. Paul?


overall this conversion bothers me, in that we need to put this
boiler plate into every hook, instead of having the infrastructure
handle the conversion for the specific LSM.

I know this is partly being done because of the
   if (secmakr_active)
check, but I think it would be far cleaner, and less prone to error
if the infra could grab the per LSM property and pass that instead,
and not expose the secid value that has to go through the mapping.
At a minimum the API should identify this mapped secid is different
from the secid being passed in some of the other hooks.

Perhaps we could have a way to store if the LSM is using the secid
so the LSM infra could do the secmark_active check before calling the
hook?

>   
>   	if (peerlbl_active) {
>   		u32 if_sid;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index fcfadd5d9994..79140e6829a4 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -42,6 +42,7 @@
>   #include <linux/fs_context.h>
>   #include <linux/fs_parser.h>
>   #include <linux/watch_queue.h>
> +#include <linux/lsm_secxa.h>
>   #include <linux/io_uring/cmd.h>
>   #include <uapi/linux/lsm.h>
>   #include "smack.h"
> @@ -4189,10 +4190,17 @@ static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
>   #ifdef CONFIG_NETWORK_SECMARK
>   static struct smack_known *smack_from_skb(struct sk_buff *skb)
>   {
> +	struct lsm_prop *prop;
> +	int rc;
> +
>   	if (skb == NULL || skb->secmark == 0)
>   		return NULL;
>   
> -	return smack_from_secid(skb->secmark);
> +	rc = secxa_get_lsmprop(&prop, skb->secmark);
> +	if (prop)
> +		return prop->smack.skp;
> +
> +	return NULL;
>   }
>   #else
>   static inline struct smack_known *smack_from_skb(struct sk_buff *skb)
> diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
> index b363c42f252e..0378f74aa22b 100644
> --- a/security/smack/smack_netfilter.c
> +++ b/security/smack/smack_netfilter.c
> @@ -24,13 +24,17 @@ static unsigned int smack_ip_output(void *priv,
>   				    const struct nf_hook_state *state)
>   {
>   	struct sock *sk = skb_to_full_sk(skb);
> +	struct lsm_prop prop = { };
>   	struct socket_smack *ssp;
> -	struct smack_known *skp;
> +	u32 secxa;
> +	int rc;
>   
>   	if (sk) {
>   		ssp = smack_sock(sk);
> -		skp = ssp->smk_out;
> -		secxa_set_secmark(skb, skp->smk_secid);
> +		prop.smack.skp = ssp->smk_out;
> +		rc = secxa_from_lsmprop(&prop, &secxa);
> +		if (!rc)
> +			secxa_set_secmark(skb, secxa);
>   	}
>   
>   	return NF_ACCEPT;

