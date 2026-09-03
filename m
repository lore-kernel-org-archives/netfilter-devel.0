Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0931400DE8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 09:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428375; cv=none; b=muWbb49gzBMOLryvEwwFt82PlocE8SVzxNlbBtxNDLazad3XH8n1fp+RyJ5G9WVCSkBkiBODVxhSs8uVeXiKJWKbFALX+Md8fVqmyN8PrViCAllK9v5dMRJG7c4CE2+IdFiQNtP+01T8AzXrjaClUNgwXejwlSULMKE9sbveyCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428375; c=relaxed/simple;
	bh=eteUzrmkq8h8GgYq7AnBB8NLtsAMTQF/SAj+F1OBPTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hP5ZpenBqQvTNvv1e9qYXi5eLZl5mhjaAJ5Ki3Gu1ieEz++hdhmHfi9yMirL5+MIqANNxjAoeuIOU6rJh7v02w1XyguTX0TC24nwB7xPX6AaIxY+fWmXpRH1cNuM88O+eBO6GAwhPAr6ZU39OdLFooi4gHs8+hJRe6+4Z4uWxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=ZvwxeX3l; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="ZvwxeX3l"
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 23C4244BA8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1788428369;
	bh=KKkLnet/xNso2VgwykzycKd8FLUzbCAtDdRFW1K53Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=ZvwxeX3la+ukS5I5aysGjGnhc0dZ9tU3buK6XpFI6YQJsGY0Li1brx0iLXjDo5Wpq
	 V7rkwlPtzO40UpY+LuJxoZ/EkhgPjqNFIPWBlIAcdEzgVYRKHKByPbqPwLL7EM/g/f
	 Qy0fmDp4lCbxT8nDCQkUhERXpWkove9jguHBptFNLh3VzcfvBoOsAdDcQ5UlEI7ocb
	 nwmRn4MXLpIdO5FjR+SSFBNh3+SQv4UAI74Ijc/2CwB0K+tHiRh5JvnTXxL/Y/JHqQ
	 5WkEDjnW2Otap9O8nDDNRc4D95ILySo6/ZPQNeRIxHi34grscPz5lh67SbEwmqTnuN
	 sq6cFZTsdsANy/dCOcQafyYLORmOVlRzjS5MfkVN8J57mQLCJI6wLWvz7TB/Uanf3N
	 Ug0lEtCTFGfnhr4HKIIObr82iXmtbIFK3n41pUATx7//tGcmBqBrzpk+yLWmai7EJS
	 C+EwYbhv/nYLzm0Ojpo/VlQUW6A+YEzakk527w/I5taxCBeR1ccxkxOeWpXg97Gk9q
	 wcsE+DMAjkeeOupVUkRTJWQexrWZz8KGotHWmiUDDJhJYfKPDCgvXnqy4ORZ0kcs1z
	 MiMvrTXpru/evX9FZ6P1xaFkyS47mfkkmKvuvDbz1RYIXIo0JMraQsY+kxgHrjiP+9
	 HLnIlooLx4HSE16h/Tsva4sE=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398d292eac1so4492527a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 02:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788428367; x=1789033167;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KKkLnet/xNso2VgwykzycKd8FLUzbCAtDdRFW1K53Ic=;
        b=a2o+agONeE4VTxWXWMrjz7wGl5glcabYwSuaVyjkkAk7TxV0wbSSI6O5Jbq+3USShd
         Kcy8dqIzEIru4W3DtBvP9Hhocj1EjaihyreSElazVLNIGWJT5RYr92OLOHoKxwFyCfUb
         6TggsmaKRCVPLjuFux4VXOC95qeeff5/6k760cpJ6Oh5h9AOOtTIhe4LIoXL0Xq+eP98
         k/uOIyg9qPuUapMFPNKq+BSRX2+e+MKfGL65kh611++Vozgh/K2623ExhFJBp9SvD36T
         r5AJi5hT6V9cbYeO8P57H0+fsrSOYeGVDt6Syr0rwzUYXVtZEua5g4O8GQNB4jjhz5rB
         wRSw==
X-Forwarded-Encrypted: i=1; AKwUvBzHW2dpjO+yloJPljv51iN5XQm9ZIfFVH2HJTEub70RWiWtzG3F5L4Gvkrin6l7zg57SDO6VuZMkJdnesqtZVA=@vger.kernel.org
X-Gm-Message-State: AFuF++nhxSELFDx7CfUDSTG79+Qw+1d4IzAWY+Jvrotud5BvA4snamYl
	eAA0eEDED/dSTeQyUY4YQZjYx2Hoo1y8DCsRwVNYm485RknB/co4xUF9YBWO4pOAFqJN9uWwgle
	4WjvDmG379RxNwOnSkDAXLDVF/KdijmamJQp94JTBZmQLRD4CWH9alDRHYN7AvK8ZpEfuU1r6QR
	9XfWOg+AO4xA==
X-Gm-Gg: AYBFou1oztHJpc0/R6EJMt2Zn3rkk+nt9nhOfU/qnKZcXCBrhb66EjSAp79OdHizsYh
	0ea3lseFjauYug5zO+W9NhWIhQsA8K3aGRJj1/qVZopxF5GcDflGtKvT4zNYlEHqfPlBrcV94Z4
	2TYYioVkZhF0LcsMSfkZb9+Ult59WIkvyrDDNA0W5ITpcSFWXSk+pEUQxGw8/lEoECCnWTRIcJD
	hITETe5lDS2UPf8XXKDhia6QgnmZtLLxOgQ2wFostw8kZTPdKG6irzucKU8irchk/HCwxgKqtIe
	WOYoyjnD4bRbooI5b1H06tAuDSBATUduEep4zNXwvCvNCwSOFv254BbWab5dds2tiHDZDaEd5bL
	pIi6BQBZjFi8AeHE=
X-Received: by 2002:a17:90a:d604:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39aedf5e124mr17481259a91.2.1788428367512;
        Thu, 03 Sep 2026 02:39:27 -0700 (PDT)
X-Received: by 2002:a17:90a:d604:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39aedf5e124mr17481215a91.2.1788428367163;
        Thu, 03 Sep 2026 02:39:27 -0700 (PDT)
Received: from [192.168.192.72] ([50.47.147.90])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-39b08cacbb0sm4360801a91.13.2026.09.03.02.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 02:39:26 -0700 (PDT)
Message-ID: <231fbb7c-0b31-4379-b02a-a79e3b9c28ae@canonical.com>
Date: Thu, 3 Sep 2026 02:39:24 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] Apparmor: hooks for secctx_to_lsmprop and
 update_lsmprop
To: Casey Schaufler <casey@schaufler-ca.com>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, selinux@vger.kernel.org
References: <20260902220150.18586-1-casey@schaufler-ca.com>
 <20260902220150.18586-7-casey@schaufler-ca.com>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20260902220150.18586-7-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


the code itself looks right
same nit on update_lsmprop as previous two patches.

I know you are working within the insane constraints of the secid, but it really
hurts that apparmor has a local xarray for secids, and now the LSM infra has
one too. I know its a problem to be solved later, I am just griping about the
current state of affairs.


On 9/2/26 15:01, Casey Schaufler wrote:
> Implement these hooks.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>   security/apparmor/include/secid.h |  4 ++++
>   security/apparmor/lsm.c           |  2 ++
>   security/apparmor/secid.c         | 21 +++++++++++++++++++++
>   3 files changed, 27 insertions(+)
> 
> diff --git a/security/apparmor/include/secid.h b/security/apparmor/include/secid.h
> index 6025d3849cf8..ba7adf2fc09e 100644
> --- a/security/apparmor/include/secid.h
> +++ b/security/apparmor/include/secid.h
> @@ -28,6 +28,10 @@ struct aa_label *aa_secid_to_label(u32 secid);
>   int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp);
>   int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp);
>   int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
> +int apparmor_secctx_to_lsmprop(const char *secdata, u32 seclen,
> +			       struct lsm_prop *prop);
> +void apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
> +			     int lsmid);
>   void apparmor_release_secctx(struct lsm_context *cp);
>   
>   
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 88d12e89d115..1f304b88eaf9 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -1766,6 +1766,8 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
>   	LSM_HOOK_INIT(secid_to_secctx, apparmor_secid_to_secctx),
>   	LSM_HOOK_INIT(lsmprop_to_secctx, apparmor_lsmprop_to_secctx),
>   	LSM_HOOK_INIT(secctx_to_secid, apparmor_secctx_to_secid),
> +	LSM_HOOK_INIT(secctx_to_lsmprop, apparmor_secctx_to_lsmprop),
> +	LSM_HOOK_INIT(update_lsmprop, apparmor_update_lsmprop),
>   	LSM_HOOK_INIT(release_secctx, apparmor_release_secctx),
>   
>   #ifdef CONFIG_IO_URING
> diff --git a/security/apparmor/secid.c b/security/apparmor/secid.c
> index 28caf66b9033..d35fdbf074e0 100644
> --- a/security/apparmor/secid.c
> +++ b/security/apparmor/secid.c
> @@ -106,6 +106,27 @@ int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
>   	return 0;
>   }
>   
> +int apparmor_secctx_to_lsmprop(const char *secdata, u32 seclen,
> +			       struct lsm_prop *prop)
> +{
> +	struct aa_label *label;
> +
> +	label = aa_label_strn_parse(&root_ns->unconfined->label, secdata,
> +				    seclen, GFP_KERNEL, false, false);
> +	if (IS_ERR(label))
> +		return PTR_ERR(label);
> +	prop->apparmor.label = label;
> +
> +	return 0;
> +}
> +
> +void apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
> +			     int lsmid)
> +{
> +	if (lsmid == LSM_ID_APPARMOR || lsmid == LSM_ID_UNDEF)
> +		dest->apparmor.label = src->apparmor.label;
> +}
> +
>   void apparmor_release_secctx(struct lsm_context *cp)
>   {
>   	if (cp->id == LSM_ID_APPARMOR) {

