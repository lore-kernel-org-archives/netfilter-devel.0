Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E315FD13;
	Mon,  2 Sep 2024 10:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725273690; cv=none; b=Q5rIh4Zyava/jT9Kq4aoSG4EjECxNegLg/fuTU017hc+foPqAc+DPGYXFq8wwaY/436r1Z/8hzKtCnSK6KbMFf63S+h/SK89FB2muPtoEobSwqvzG2UnZc+kdXZV7vbyH51OaEWdIcCJvvbC6Nh5fNroloCqoB1L3iyQZj4l/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725273690; c=relaxed/simple;
	bh=GARi0dW+IDquW2OJn2fLaIDDXhEgMsv9nwnKhMv8pVY=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=X2wp+sR4cFNr8kWFye1udJopliR1R6mR2sU3eNJeE3lKFtBBxNDUPv9Gk9P1UHWvciQPZTAY++R33Wm9f4vmfaqhaprjITL+XKOypG1yUmirwer2p5YLHrKFbJWVi5qw2elJ97+uTjOFRQk6Z+nl+MkIBAe9L4it68SPdlvFFkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNG0oxMW; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNG0oxMW"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5343617fdddso7003029e87.0;
        Mon, 02 Sep 2024 03:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725273686; x=1725878486; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qwH47m94zEL5WR28EXlB8tmkDNShZPBPvpItP0/NTVk=;
        b=UNG0oxMW/s3JhbAYyezyDMxS5Zsqy3R+cOXUk6T8u0/EuI5kuvMz/bGnK1O8dYrXx8
         rmgBqg8v2sCrKGC2moD92YC/UdaD0eL30xJISkCzuKJlHqN7L/62sBSO4ANEMNhEeDq2
         ePkV9sCnt4tHKkr0GKBSxREKWUJMcMzPjbCZJLewoBRDgUnq50wiSnvHV8dD+0xlQXue
         FnM0G4bLbIAsq/I3tq0OqQrPmXWnBkrUjs7Lqn1SGydq3D9Xpl/LKHAfgPWG7LF8u0R0
         R4VsSeZYGwaSjYKQtlkiBNOAM/qnWXBNvVGWYmMvtV14sxA1myENwueiC/Es1S6waA6m
         Xc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725273686; x=1725878486;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwH47m94zEL5WR28EXlB8tmkDNShZPBPvpItP0/NTVk=;
        b=UGf8aywYAhWqZFbAcjanMMLiU7/NUpUh7hnIgw0De02nmgzPQ5VkGLNO970Za9A69o
         GqRhgPf/KBvmMYlWAPpMRhEzDiGxm+FBvqmkVNFe3gQ1lKSxZpmh3VQ3X/0W0FxmjBfy
         WpUCNt0rJSbh+hEo8WATbDGLUWmhx7hWkdy/yoiSUdka1J7Df8lwTTcAbAM+hmdDyt/I
         LDmMTRT7d9JkijLSirWvwQJLbOd+6JcpC+AYDC1fdf1RVpdebXFoLg8POFrNZ17Hnz+1
         wN+M9U7a5+LanpklKFL9HQyJCtvTu3zgWh6Tp9gqLRdwgxlKqYiiDAdF5j8CzE+k/JOX
         zTaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjeQ5a6AZGga7Tj6hi/rfr/qG662qRgHtv+Moe40hDBGo/DtxUi2SdFPAObKF55rOnhGx0Iyg7pbN4/01Zhz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YymPMYo5e3l5aPjibI0nwIYDiIX4CIAVLlJPomv6oqJbWgXLW1c
	lwXzla1fHXsj0BXqoNZ2Vr9hgpHwZsmxL/w0yKxdW1LTlfscj5Uvjvqs1w==
X-Google-Smtp-Source: AGHT+IHK5EoD/x4brgOhFSzISZQ+sJeBhPurVOC+QHPyOJdBOiB6C9IePy1TzYMjgBQ999kZn1b+aQ==
X-Received: by 2002:a05:6512:131a:b0:52c:e17c:cd7b with SMTP id 2adb3069b0e04-53546b41f62mr9719411e87.22.1725273685765;
        Mon, 02 Sep 2024 03:41:25 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:54ae:7bbe:cc21:9185])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989221c24sm538240966b.196.2024.09.02.03.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 03:41:25 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>,  netfilter-devel
 <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] netlink: specs: nftables: allow decode of
 default firewalld ruleset
In-Reply-To: <20240902085735.70137-1-fw@strlen.de> (Florian Westphal's message
	of "Mon, 2 Sep 2024 10:57:31 +0200")
Date: Mon, 02 Sep 2024 11:41:16 +0100
Message-ID: <m2ikve2v8z.fsf@gmail.com>
References: <20240902085735.70137-1-fw@strlen.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Florian Westphal <fw@strlen.de> writes:

> This update allows listing default firewalld ruleset on Fedora 40 via
>   tools/net/ynl/cli.py --spec \
>      Documentation/netlink/specs/nftables.yaml --dump getrule
>
> Default ruleset uses fib, reject and objref expressions which were
> missing.
>
> Other missing expressions can be added later.
>
> Improve decoding while at it:
> - add bitwise, ct and lookup attributes
> - wire up the quota expression
> - translate raw verdict codes to a human reable name, e.g.
>   'code': 4294967293 becomes 'code': 'jump'.
>
> Cc: Donald Hunter <donald.hunter@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

One minor question below, otherwise LGTM.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>


> +    name: fib-result
> +    type: enum
> +    entries:
> +      - oif
> +      - oifname

Did you intentionally leave out addrtype from the enum?
