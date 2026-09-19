Received: from mail-qk2-f1.google.com (mail-qk2-f1.google.com [74.125.230.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF05156C6A
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789828518; cv=pass; b=CXp04OJjgf2DuY5G8ueWDOJ+7DL3JmsL/bjjvSB2OoV0Tl5C9MwUYZUNcK5vt1YVlVgAOh0Np1ktdhvasMvWmczGU51wXtWiHXAZL1MxwWv8uP9TdrpI7CcIYTJcxbQC43zByP9d9JeP629nz8WMWthmYRA0dL6rderVaSOp/dE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789828518; c=relaxed/simple;
	bh=8saC3WK/Tc2ObLz85Zwc7YvU1ZkWTm9hD005/9QnwQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SIdmk62rKFdzZ5zkhILuuyMkTmkTmtQchTVfMMuDYVKd5wr6Gh0mf16GKOsCbpmmTCgewHqUbx5ETgL7l5ezqkMXuntFttj5epUNA6dwFfklMpJkq3HKOOQTbF/1VFBlgjzD68RffQ0VeoqQ4wg74U3IXiaxyOq+3jZGS/7bxIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjYsofwG; arc=pass smtp.client-ip=74.125.230.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjYsofwG"
Received: by mail-qk2-f1.google.com with SMTP id af79cd13be357-9395921bc31so158597885a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 07:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789828515; cv=none;
        d=google.com; s=arc-20260327;
        b=RvYy3sLbo8LqjQgBfabnZj3BOXcfYo8A6CKiJe22i2MHyfc4JtW5VrQAucGAjMGhca
         81P5j7ddIogizDsSo87U/61JtCRlyRJqgQIDxFixyH1o+avlU2+xcI6DWFCgizGsyL0A
         /7oLJho330MMa5bn69rdpNVpuK0nIVtoC5sLhRnUIWhVKn86RLtKY3qWy6zF0mLrKV7i
         w5N1xDspsHAQvRjCO4/nku+Vh/MIxUYYByjHn96uPUs2wzH7otTuW7he215wik/qxFGf
         n0nUluekXRUFJ8Ouv03mwYFCHku+XDFMBZVog5Vq6xBs20CxM8Ql3z1bkX6+ybNdeGsC
         pi8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8saC3WK/Tc2ObLz85Zwc7YvU1ZkWTm9hD005/9QnwQE=;
        fh=EOModxpWtNyGxZ7/8l8fCQq/rDkKsYGzoaQvawC0omc=;
        b=WZbSv1SNqrSdhOsBPJpFaObd2BO5bpfmd1NIZPngeAgJpjwsmG+pLvH57QVcQoNyBf
         ct6CT1mKHXtvKxr1ShauVfuHiyUrL5VEA1TmyP0gFus5UA5iXPNWAsNFsHKn0ABqoSrj
         ODrErECwwJVKpGKf2FVwK+D+6V01VEooJjWTH8kvH46Z7nLU60NCyLI/zAHW8JexFvEq
         g96/iljkLP+iwj1A8urhJWxoRS/p42WhscEA0yyAm1W8tlZCdYyHV9VG6Gq9t/mAQ3BR
         Q0A84m18E2f4B6VClGtP+ryXER3VqFpOhUVgH4i7crVQeH2HMpVa0rxH9YwVvuaNiY3J
         g4Ug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789828515; x=1790433315; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8saC3WK/Tc2ObLz85Zwc7YvU1ZkWTm9hD005/9QnwQE=;
        b=AjYsofwGvjSbIDEo1UvrMpnB5dpmXCoIrhzxlI5kMrLCvkKWB62w3u2r9ZOfkUTvRT
         dXsIMSzOpm/7DK9dRRn4rrMyuoh+FdFdOoeduc1feE2pAKuw3eRsDv8UJ5Ar2MCnEzj8
         Chyw+R+G7ddQ3Hy9WAni7Rsf+p6eWO61bQ+4qZ09GFerz8bEC3PchNEyZy023VN83cEY
         1I76z54Oac8ky4rnzF9p5oTm4o/+3/sz/Sv6IRIeYpD4Po6ss88TyBg0ut5jWyaegPKV
         0TTqbHBF4gbn15hztc23hSTlvqXFlUQhxnqI409r2DxK3vcVOn1dwpdz3WohU2kMYOB6
         V6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789828515; x=1790433315;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8saC3WK/Tc2ObLz85Zwc7YvU1ZkWTm9hD005/9QnwQE=;
        b=Jb6GkaLtH8UdvrdCxe+1LqrdZJgw0WbKuHT9nani4bTltEjCBptsMpm1iJ74yRMNVs
         ZSw0YVyFTuV4nKzHxg2e2llLuXAzbN0iiK//Q6Clma4mjJJ2iJ2eNewZi4x58FnCuVWb
         C73/aFx6LSROrFmq6GgEC0uzYv0WFwZmPxQxmFqvTl8OaoJm4vVWRAnN8OD4Mxgh8IKS
         m+dAzqVqra1+7eQmOuvN0CgX/Gp1qbxKnVIW6nX5YOkCnsBOP/LdUNtT1r7JdsB8UXF6
         6riI13dISKHYTglPL65UZRyuWS9j9krQhL1rA0xTYuuDyKbvGb0+4K2m3wHWOUmnRotT
         czTw==
X-Forwarded-Encrypted: i=1; AKwUvByWafmi0y5mkVwMHGhBVCR7pZHqQ+VBAdALWXbaVVQjKoR2QjIywy7jW7qWeCK38IYjeV9bQbjO+cvexmR7kDc=@vger.kernel.org
X-Gm-Message-State: AFuF++kYX37rFD3bnQf1XuzNBD10u/ufuKfwm+Qs7fpNXSA0gBF46S17
	/BYmvfwrH32fA26c/s4pkzWuWxc8UZRAiSdkgeXcZhQ3ILczOQFlBpBOLZb98qIT0tj7AVQNYuH
	3GE0fx+zt9ze6a1HD/5SvWfx2wAgJFMk=
X-Gm-Gg: AYBFou2y4W4XnPEKIs3k+Tq4gG5noaP2ZPimNDUJqXJ75QNzriFWeqPuwhlx7oAT9gZ
	eHGcJ2Weo/zGBaia/F/19pSyjnRHeYbWhCwm1KXpt+iOkGhb9qethzR76JQXuylYVufe6SznNfC
	kxjUTbzZMr2/rYQQgSVEiJO92yncI4LJ/gD1SQZTjs7G1/Lxwq82bcXisa2R0XR63QTdpPqLLhW
	w4WelF2Y6SOI0YIJb/Ro4UuAqLzQkF6u844tUfQ313Vqqy4zqCIw4b30K1slAvIHCUSgf+3DR+C
	rYwyKbOEbAsf43iy8FPSNa/m6GTdO8OO/n4L3mP81plndlB2Y47xS5L65tZMMh7IrQ==
X-Received: by 2002:a05:620a:4808:b0:939:1459:efb2 with SMTP id
 af79cd13be357-93bf55953b6mr188632085a.24.1789828515591; Sat, 19 Sep 2026
 07:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789660425.git.petalzu987@gmail.com> <aq0UpHHbvxjR2jLb@strlen.de>
 <aq1HaYS96SNn7HJY@strlen.de>
In-Reply-To: <aq1HaYS96SNn7HJY@strlen.de>
From: Zixuan Chai <petalzu987@gmail.com>
Date: Sat, 19 Sep 2026 22:35:03 +0800
X-Gm-Features: AcwNN1X3sw00P_oKgwlXDKMU8ulsrx6Q4wcrphBpx55MN9FfmXdSd0ZhMooLvPo
Message-ID: <CADTzad+sgZSw78eqSo9VmVBRHRej+=Oyu+eP8HvzLyAokH6qTg@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum offset
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"

Hi Florian, Pablo,

Thanks. Agreed, these are separate issues.

I'm working on a follow-up patch for ipv6_skip_exthdr().

Thanks,
Zixuan Chai
