Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298016DEC3
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720787339; cv=none; b=bx2TJ4g1ZCnwQbN0CobZNQlynVEqR1kRsRwn7Db4/mrf8UC5nUwuidTUp4wxfR7yYmOOHfhf4Pz0YwsDm1IQZKh01MfZ++tlYeehNDwGRinKZURxFpganPoTjwwsl1SkP24toK7BJXJjLQ94IEerkX4Fgl1J16A+uTq9dtHGOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720787339; c=relaxed/simple;
	bh=Lyu8o9+iyTEiPOM3IyFfI/SpsndBbp7ZlC6l24T6wqM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RhKX1NPChlvirNucCCjTrmq7LmNhAKpTo4dixLM64YVSRT+CkwisVgjZIASbNFF+dBc7SUhA+7TWpK/iSu6rrW2r2vuOR+RJK05Lu7nG/IA4Pipt3fNFsNOFXjgLujokUg3i7Y+cAR1HEW275dcTGqGXHmr/vP270R0LSLI3Uts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SsNmSAcb; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SsNmSAcb"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52ea7d2a039so2020790e87.3
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 05:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720787335; x=1721392135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+T2daRH4oYJ23ZWOQwTRmvyRDh9vM8AZS/lE0omlcLc=;
        b=SsNmSAcbLbTFihcd+NJ5Oy8gbZe8rpiIY6gV4mc/ytwDkC1vKFf8bSL280akJB3Ek5
         DfwepJPtoDNdg0LjLehFslycd5wXyGYX4nWhQzfYOEu4+5E7YvVE7Y5aLacxoLfNVJJb
         Hqgnbvd82Im+jCOt6KHhASP2ofxNlC3ZYCwmMXY1fJiUFhfqevy4+rvhSs0NUAKimLor
         dG9KreLWGaZcRKKdKjllrXxxzlbSPtkecuKRPmo1++3XlSzLLodpeKrTS5qgxttFg7XK
         T4YVDioxQdsiIPHZwzrtWzbdDtAtV+yyO/WaKNBwR73UeYWJVqjez8eSYl9v5qj4xF7v
         Qoog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720787335; x=1721392135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+T2daRH4oYJ23ZWOQwTRmvyRDh9vM8AZS/lE0omlcLc=;
        b=cxd6DtFN3xn8Dn3gfAXQdEoJd+nAHzgJihcOw62IDRsVXLRkq0+8RXU6cMQFqTKeo3
         eQhcOoeBmE7IpfajIvBijYTZ9Eajnt7j0VgYF35QP5DJP85az1F77kQEdrEPior4p0Bn
         /+kjwcSW+2fl+KFkx8ppXpaZzhqACFBJ3vF/dLZZUn5WFxvfyUKpS9YRx1prpFVzzisV
         5ODUOzn1LkhVfon9OUpmj2fgYp30WzgTYt0sdVOZrbPigGWWrb5OGqNFsCSPkZleZmpB
         kUEsIBAD0LRjV3UkmIVS02fxKjYiUhRkIhgcncTEcVaRJWSBXWPgRZNWoDITUWd6e5oG
         qfRQ==
X-Gm-Message-State: AOJu0YwFMJyhQVt4e8AWvtzqekhLOJwe6/KEo8CRqKqU+rX2k61/s8+y
	VLPNyHVzXI1OK0thcjHnsKBJ3DIv+aWMTlPwxCmdrc6JziWSksK5e8Bnog==
X-Google-Smtp-Source: AGHT+IFbpDzG5caOghYPpvBD5dNUpwfLGIZVnjTTZ8NRIa+wDql8CvdNegFIor54TiT+kXC8BSDfYA==
X-Received: by 2002:a05:6512:3d93:b0:52c:9413:d02f with SMTP id 2adb3069b0e04-52eb99971fbmr8536250e87.17.1720787335078;
        Fri, 12 Jul 2024 05:28:55 -0700 (PDT)
Received: from localhost.localdomain (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2cc2efsm22451315e9.36.2024.07.12.05.28.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 05:28:54 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables: Fix compilation error with musl-libc
Date: Fri, 12 Jul 2024 12:28:54 +0000
Message-Id: <20240712122854.1108321-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Zo6KepEjo7IHOpWb () orbyte ! nwl ! cc>
References: <Zo6KepEjo7IHOpWb () orbyte ! nwl ! cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Phil,

> Man, this crap keeps popping up. Last time we "fixed" it was in commit
> 0e7cf0ad306cd ("Revert "fix build for missing ETH_ALEN definition"").
> There, including netinet/ether.h was OK. Now it's problematic?
> Interestingly, linux/if_ether.h has this:
> 
> | /* allow libcs like musl to deactivate this, glibc does not implement this. */
> | #ifndef __UAPI_DEF_ETHHDR
> | #define __UAPI_DEF_ETHHDR               1
> | #endif
> 
> So it's not like the other party is ignoring musl's needs. Does adding
> -D__UAPI_DEF_ETHHDR=0 fix the build? Should we maybe add a configure
> option for this instead of shooting the moving target?

Yeah cheers adding that does indeed fix the build...

I have added a configure option. I will submit this as a separate patch.

Thanks,

Josh
