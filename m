Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0053CF1E1
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 06:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416154; cv=none; b=boHVMT1NcxezoOsDWnVf5IOfPvTyAN2xWda0Yu4WtlHEyIJnsWwShR8ymC1S5RzPwVZTzJ6SZUevU0q/pGkNwGSnlGXcIf05/CC2nCtD5FHN3lJa49nzbsxJhlD2LjXatlaKn96y+U9McZTbZMc14Ta2oLoWL+m4J/OViAxEQEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416154; c=relaxed/simple;
	bh=wpl9wKkbJFGy3u71BuJLHaA4TN3RjLmyXn7wBnE/sZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RK3kj0EK3IrdeHU0blpOYJY9K5RZPP/6+5fW3YBKNTFYsluwkwSZlJIzv5Rq41ifiSJVNL3KND8S+IPabRbTyaTpS1gCjxHcnXjoSPSIxqWfK25LLDZ/6ri/8uuP3mIUi87ewqYLTJ0Mb0vZVL0JLmPwzul72EjJdP3Ee7EoupY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=CWveD9Ei; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="CWveD9Ei"
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 104DC3FC14
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 06:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1788416151;
	bh=KUWZRyqFeEf4s3ueoyPuRgRthTlv7fXXCaa5u+oHG9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=CWveD9EiNBCrYyOTQYcrC4UhijWm+YW80NCPxVXFWm39SkItRMfgYMchzR/sELLjc
	 yKFSVq3XT7e36B+8MckbWqjKOIWskX0iFR4GXS/Xheql0qhqEUu1y1uK6E6DPaavP9
	 0OIe2Qs0Ffj32fdYs0e7jiaFM+IF/faPG+Ab/1yDMZSpXQJtHSDC3JKIcGlNtQ0Leg
	 Ujym704xWrKyIv1IjcbCxiJuHV73jIeyzW1yMBZE89gp92jWItXlscDshx+trA9ybr
	 X0nxzjv62AQkYVlE42eLtiUkDpIewBKqCmpNMhv4mQk7hX4eYpw/tGWTvplROwc831
	 HuLNW2Ntrp4UJT/UIVCj8lVYiLtyiRLEBEo1EOsLElfZlmuJQmUDqJX0vyywi3+717
	 vCXWf70VH+wUptCDxgfTwORZFHCaR1rXg2XevE/dgbG17HkkJBwx7gT4hzJkplajEx
	 ECmijjTsJRLsJsjAOvWktHk6Hk12Bol9Zsio7QNOIorsGw4kesfvvysw0iJBnsz0un
	 PtlSCSlh1R7v3GJRDQZnP4vVFfz3XXp/bm1/gsQSk+yIG3P5qy38dMyETk1uGVWEUt
	 bYworYPJMRrn1nb0HkAPC7jeKnpz/GHYQoekHrVLe4dsfEnaSe6HjDcxRVrIuzHfYD
	 htXKprw9MyofYCDrAOyaDDiM=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b6f65dacso2376553a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 23:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788416149; x=1789020949;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KUWZRyqFeEf4s3ueoyPuRgRthTlv7fXXCaa5u+oHG9Q=;
        b=bk+8ZEMnFfHoJJ9nBcE46CPgnRPaXMhuz6F7MwqCWXTMXHt7DOVC+OXWYDdsODUxkC
         PBEKYQ8qg50+05yanZ2w0c4vi9K8XVlNuce7db8ozlrfODlAXClYPd+Ok8HlH7ffxCko
         1iYA4HjzwioGQSJ4uZnOmbaTY8NQbfYVFXuVNoTM61bFEirgrh/gUv85wYJvfFP7wQCs
         S1ggkddgKqsYPLewLrh7XAaElXqqt36ENHYy+TrnEZCs04NklMhoUsCgiBqnwBvJXYmj
         qpN8CP0mvOReROc6gBn7GZZ21UeBAJ/FBoyI3OIUOQKtt/dyy7ROjIm8exeRLArvYixc
         FNNQ==
X-Forwarded-Encrypted: i=1; AKwUvByN4nHBYCdNpSMlAIiEXX+8lTEwZzLRYoY+aHpDwBkDehCPyQzVcq1mVsahE7fROd9UX1dlyXEXWH+BrrjuoBQ=@vger.kernel.org
X-Gm-Message-State: AFuF++llp84s/QLrUqconQvI4aZD7TuO979RwNhJEkrgaFETfAT/N4yG
	7EKU8j8Osss2CLC7/C/DEwTKqIdDGi2z0OKksBsINZopwe49vFkqVF1Ma5aMajEG8bAwI2Q3VRv
	UEL+J0QwTTJm6u7eAh/VoKy3QNSF4Zl5nE9ZjDQLdJfpS3t72Xgsn56KC/AjDxrYE6XcZJtpbG2
	KL2iTnFrkHjg==
X-Gm-Gg: AYBFou3YZctMLflQC2ystLuMSBWUULaJAgu20sO4C+fdDlDyiWNcWlUNMRocwRySdne
	b70HLbn2guTi6gSZEvy7QqxcageU2r+zG0E9Nhr8GkD63LAXmpTwVUFKujs82RIt9/NqppoogBV
	PnolHuO1YX6ag987zUK86IzJFjaXwBfLJNE67RHcyblYQ1EmJ8Ib41ytrqS9Zlw9kU+abznwbJz
	oDr4aNTR1fjyMeV0bRILPmMV1mxglRbHwobCqeawQYBCrqWf6ILx/ujEa6AGyTaz0/xZFwmlibw
	Tf/l0C+SYCWO/g9sgV2ICAdQuJJg9Dt4UE/PhVR4hhsWqA5FzrBMH7zBrR61EaLaC9acqnUsQh0
	/88RIuPS9Z6YtyWw=
X-Received: by 2002:a05:6a00:e08:b0:82f:2b0:2809 with SMTP id d2e1a72fcca58-85ed7158030mr14968922b3a.1.1788416149458;
        Wed, 02 Sep 2026 23:15:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:e08:b0:82f:2b0:2809 with SMTP id d2e1a72fcca58-85ed7158030mr14968878b3a.1.1788416149103;
        Wed, 02 Sep 2026 23:15:49 -0700 (PDT)
Received: from [192.168.192.72] ([50.47.147.90])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-85dc003a7d6sm2259856b3a.34.2026.09.02.23.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 23:15:48 -0700 (PDT)
Message-ID: <ac628baf-3c8d-4f8b-b410-0c10990bdd1d@canonical.com>
Date: Wed, 2 Sep 2026 23:15:47 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] Smack: hooks for secctx_to_lsmprop and
 update_lsmprop
To: Casey Schaufler <casey@schaufler-ca.com>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, selinux@vger.kernel.org
References: <20260902220150.18586-1-casey@schaufler-ca.com>
 <20260902220150.18586-6-casey@schaufler-ca.com>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20260902220150.18586-6-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/26 15:01, Casey Schaufler wrote:
> Implement these hooks.
> 
beyond the question from the previous patch, wanting more in the
description, and the quick double check question below.

This is looks right

> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>   security/smack/smack_lsm.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index ff115068c5c0..fcfadd5d9994 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -4909,6 +4909,37 @@ static int smack_lsmprop_to_secctx(struct lsm_prop *prop,
>   	return smack_to_secctx(prop->smack.skp, cp);
>   }
>   
> +/**
> + * smack_secctx_to_lsmprop - add the smack label to an lsmprop
> + * @secdata: smack label
> + * @seclen: how long label is
> + * @prop: where to put the result
> + *
> + * Exists for audit and networking code.
> + */
> +static int smack_secctx_to_lsmprop(const char *secdata, u32 seclen,
> +				   struct lsm_prop *prop)
> +{
> +	prop->smack.skp = smk_find_entry(secdata);

just double checking a null value here, looks to be okay, but just double
checking as I just did a quick skim of the code.


> +
> +	return 0;
> +}
> +
> +/**
> + * smack_update_lsmprop - set the smack label in an lsmprop
> + * @dest: destination properties
> + * @src: source properties
> + * @lsmid: which LSM is relevant.
> + *
> + * Set the Smack entry in the @dest if appropriate.
> + */
> +static void smack_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
> +				 int lsmid)
> +{
> +	if (lsmid == LSM_ID_SMACK || lsmid == LSM_ID_UNDEF)
> +		dest->smack.skp = src->smack.skp;
> +}
> +
>   /**
>    * smack_secctx_to_secid - return the secid for a smack label
>    * @secdata: smack label
> @@ -5269,6 +5300,8 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
>   	LSM_HOOK_INIT(secid_to_secctx, smack_secid_to_secctx),
>   	LSM_HOOK_INIT(lsmprop_to_secctx, smack_lsmprop_to_secctx),
>   	LSM_HOOK_INIT(secctx_to_secid, smack_secctx_to_secid),
> +	LSM_HOOK_INIT(secctx_to_lsmprop, smack_secctx_to_lsmprop),
> +	LSM_HOOK_INIT(update_lsmprop, smack_update_lsmprop),
>   	LSM_HOOK_INIT(inode_notifysecctx, smack_inode_notifysecctx),
>   	LSM_HOOK_INIT(inode_setsecctx, smack_inode_setsecctx),
>   	LSM_HOOK_INIT(inode_getsecctx, smack_inode_getsecctx),

