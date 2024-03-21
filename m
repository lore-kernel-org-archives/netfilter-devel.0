Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0B5730D
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711018357; cv=none; b=feARx6D8a5BEidQL6GAPJ3raUy4MTmb+vUqcz3eN+rWSDzTLzKdzyDratz+a8GOqszNbQaLEwPOBfddJMHoHnrn1XFjx/4JeKG+OPMANb3r1MIii9JOavme9O9lhYM6gUQo9pY91cXFUXFLod2GjMOxXA0TWsy1+cReLMojRkm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711018357; c=relaxed/simple;
	bh=gsoCm4Wgk2v70XacpU05b7R7RosfW3s9rjwHL5092VU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FyVPUwHylUx++JXdjBq3rgEBQ/76ygIN8LvjI6TUXCp0LY/kQ7+3qIhjtKdbQH120EEoSe07PsM7OZ5S6Dk4lAgVIKO1KvT0wE+i2SYpbM0ClCXKtPUcpHPgM230mOuVzp+YneDOpZpvLa7Qus5dee7VAX7zio566yfWrt0aNh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lx1l+qmF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lx1l+qmF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711018355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gsoCm4Wgk2v70XacpU05b7R7RosfW3s9rjwHL5092VU=;
	b=Lx1l+qmFq0b7GIOB5FNLPyrSq3SdUPX6D0hezI2EEOKtddOjrHGprhHwTrmQGAAghqhHiX
	lTREQoJxrcI2wTdM2/3/D4DEUHNipXYJzDhFw5Tnq8R9LGD8DlwmgUAu363INOoMtmu5mQ
	ET/zCUmA02ZCysyJ6o9PRvl/rJJHIQs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-OlT4J3XhMlmJNWxHJ6ROhg-1; Thu, 21 Mar 2024 06:52:32 -0400
X-MC-Unique: OlT4J3XhMlmJNWxHJ6ROhg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41472b798a2so1618865e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 03:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711018351; x=1711623151;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsoCm4Wgk2v70XacpU05b7R7RosfW3s9rjwHL5092VU=;
        b=peCXlJeWYeFKGq5L9FS/psvO7C1lxmRzitZbLpEff6epm4Ufsq/YyM40sAeKROE1Kn
         OEzI29BE/7dwJktkIXFTFUprWB4XDC7Q2r2hFqmq66Jipj6/GTtyIbZ7aWD5pFs/86hI
         DAhFnIYGIqmSERKe3ETRlCIlCi/BJqyNZxEMaOnyFB3RbTdvW9mpDeM3LcAj/g8oG/5X
         ZJkW/hrfzyK7AoMhSjtTs+2hO3HtDp84Q9kOrlDX8igl3dpNa25mQLSvp+p3L82CYpZP
         90U/vKRrY6I4XCKcIWzCgUZl9Ax7Z6eY1ibTnOy9iIvESAqjiQvZd1AEUJ+ZnjLISiEx
         LYoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEvjZxs61N0jisF08uifGIchSB6DBztdMb9k8SmpZcfAMqIHRU907xzrGmuhiJfch762y7XiWMbs6C3hQ6Tix/4HV/F6hvT2CmeCEzkHp6
X-Gm-Message-State: AOJu0YzfDB4WM12nvYDwhPX5J5sjr51pAy2LDcM5lVLg3DyxNvUUoWMK
	rQSUluvQ5Dp9uXZOQQJjDLbx9YygESe4NSfBz71p985D12q5qUq7c1yZkkRGVI8U9d70jUSNU9c
	gUAk1m3bkzM1BoJgjr2CfgMkwaRIai70+kNtxTT4238394jZRHiRJikADuO3l9Cmluw==
X-Received: by 2002:a05:6000:1849:b0:341:8f18:db39 with SMTP id c9-20020a056000184900b003418f18db39mr5641233wri.1.1711018351690;
        Thu, 21 Mar 2024 03:52:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC+aYfcvUIaLD708MwzlkLyOTxpcs2HGHrfSDGKBbltBf4gJYZfWTB0xukFigbeuvwxrW7ug==
X-Received: by 2002:a05:6000:1849:b0:341:8f18:db39 with SMTP id c9-20020a056000184900b003418f18db39mr5641219wri.1.1711018351321;
        Thu, 21 Mar 2024 03:52:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-249-130.dyn.eolo.it. [146.241.249.130])
        by smtp.gmail.com with ESMTPSA id bk12-20020a0560001d8c00b0033e88eb0ab9sm17143460wrb.11.2024.03.21.03.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 03:52:30 -0700 (PDT)
Message-ID: <1c84b33599ba6d10680162a43ea729f7353327b3.camel@redhat.com>
Subject: Re: [PATCH net 3/3] netfilter: nf_tables: Fix a memory leak in
 nf_tables_updchain
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com
Date: Thu, 21 Mar 2024 11:52:29 +0100
In-Reply-To: <20240321000635.31865-4-pablo@netfilter.org>
References: <20240321000635.31865-1-pablo@netfilter.org>
	 <20240321000635.31865-4-pablo@netfilter.org>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-03-21 at 01:06 +0100, Pablo Neira Ayuso wrote:
> From: Quan Tian <tianquan23@gmail.com>
>=20
> If nft_netdev_register_hooks() fails, the memory associated with
> nft_stats is not freed, causing a memory leak.
>=20
> This patch fixes it by moving nft_stats_alloc() down after
> nft_netdev_register_hooks() succeeds.
>=20
> Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new device=
s to an existing netdev chain")
> Signed-off-by: Quan Tian <tianquan23@gmail.com>

I'm sorry for nit-picking, but our tag verification scripts are unhappy
WRT this commit, it lacks your SoB. Would you mind sending an updated
PR?

Thanks!

Paolo

