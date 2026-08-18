Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB76E477292
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059145; cv=none; b=Vv678JluczPCgQcqMrZdSJ/8G9BwfE+tV6jeOtQ6G/KvDtxpzdmqrFbFl4wAYZhnltIk5Oad5thg2T/+h29LhY1Zq+9RnabPPvc7ZlKg22+3bXhVDnFEjUgEJo+efgXdW4I8DCigqZwyofdMMGNXc6UN0KDcAcE0GfoYjKDi/M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059145; c=relaxed/simple;
	bh=K9AYjcSpVCzONxZZ1QdyN/huFM2O2T8f/N4CMMgl9Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cZkiNN0I+u+LjgED2ZAziE0JLemhg1/OAX0ma6e7sWTAJpEAiXC1udRzVsMFmv4ycFBBb3Pt1oZytl2DBHEEGVD33Qijbst2enu3GNJv+EqKBoLj/zVqnjnTAG0XEeueNx8WDaZ/dAi4baL/1J83/eiRfEYSce8wysUNxZN2KLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9nF6+I2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6jX66Rg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9nF6+I2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6jX66Rg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787059140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9AYjcSpVCzONxZZ1QdyN/huFM2O2T8f/N4CMMgl9Jg=;
	b=F9nF6+I2DUqZKX9O852wFg9pUCxe0AOVIqpjb4GEtWHo8F1DxkDQvmVBTGCPwUqEWvwhEC
	UHIW8DxSSbzuinMgb7c3CC7fY4VrFQfk5GdOaCu4UGFC1NzMogdB1sp7XoPamuXJTbAD9F
	taY5VDI+w64UJlJ/uC0QJzxS40p74Ok=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-IDpmmBBGOM28tlPF4sx5Ig-1; Tue, 18 Aug 2026 09:18:58 -0400
X-MC-Unique: IDpmmBBGOM28tlPF4sx5Ig-1
X-Mimecast-MFC-AGG-ID: IDpmmBBGOM28tlPF4sx5Ig_1787059136
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69e984607e7so4780008a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 06:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787059136; x=1787663936; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K9AYjcSpVCzONxZZ1QdyN/huFM2O2T8f/N4CMMgl9Jg=;
        b=H6jX66Rgwm/iDHDxa6FB7cIU7qUt3jCybU/LSrVZuBiUvSNo/4Owi+phP09L5PGx7j
         ZSK2fPGJA9m8jNdCZIU32H0gyBqhN7Dp1FhZSBVuqiK4ZdLTU9hrwQyJ/wqnfBnLsCJN
         fHuR8MKU49fBDZUom10nylf++OxdZjskuop8+GChvJlUMXrcn/o8HA2Q5/5TJIBZhH8r
         iX+QeqXTHa/2K35/97TtibNRzJdJcjWZMdcaCyXZucfMqU81fiqddpwcDQNcxrrkHCZU
         WVe1bME+8u+CXYKengb6ze0OLHkcCPTNP0kk9QDUZP4lLDf4fGxjjrMKqrcEUkX7sW+u
         aLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787059136; x=1787663936;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K9AYjcSpVCzONxZZ1QdyN/huFM2O2T8f/N4CMMgl9Jg=;
        b=cyXyjkOoHHcldvt1vEcOj8+webtRFqdOlo5RltulCWH/e185iMNiu7qJgw4IalmBYe
         wDQRzcgeI1WVTLCZ0exCvk3uziTT8YWf04OISNn9V2LGNfWlA10OHb4Q9MmmRj3Hg1rA
         fzObtrAARKEpdhNxNNbOBQ21vrK42pjBZQLjMrrqh4bGfl5oFFOi7TKO842ytTy5Mj1s
         XLrE9HaJbmmTezMFg+da/YMQIPMJbA0PQImkCLDBUVjjZmMexttZtBOa2mNBocEuX5K6
         nOOwapbEib1Yb/xjpRoZETnqWqslYwFRvcfCuB9N0TwlpLdALU0VNLjigdVrmBISAncZ
         uSMA==
X-Forwarded-Encrypted: i=1; AHgh+RrTxOBRvyUPsxUcXZPk+v0mMD4HMOHxIQUntFwTM1SO7bdnA+/VLRlCW0m5UU/+/bvf3mFGXr1ErIEuO8Co3H8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+1ku++YnjLweR/VwT29wPvXVwxPtLxukHI1FKukL7uVLjiykD
	R/jmyOcrtVrmNX90th/IX/Fg9eHZjp8A1RzoPWCTVmbzmJP06W/iP1iOs3Tc1YjfwQFZqQyiIyo
	EPnPZ6gPY2AjsV3DXPvA5Vu59sKRYkAQ6/FXrnauFl14BjT30yWQjRR63tSf1+lc3Sj11CQ==
X-Gm-Gg: AR+sD13tRRYbJnzgvyINkNsNM42s+Q2zIVto1i2B1MS68WEwpbG08UiigkjHqUSUR79
	zMCBjK2nvOxBMFlvupba/har83yt33St+4/ZxfS5dtOOxIhuWNOewYI0U15IT6/ZzeRX8DgyDSH
	ZF33RtQdJanhos0uG+ka+Q/nx+6MkxA0D4HbjMJYS09OUGC+1yAJlaca/Q3JPN8bp8tk45wiP2w
	G7mGhqzwgl0KdeYeeOMOaBhYDjo5hZRT+lV9tCbh0B0bXtZbT5eSxbyfMajSYBWvjiBCnCSjScT
	8vWonLwFoSglaA5IUwgjHGiTEyXDn1qFJLK/EDFAW/4LnHHeHHrWUdG+J2cSYF+3Mt8WBpM56Yb
	xferIlc+aTBbgx5i1OZF9NDfqJThfzWoQ6jVTHNhxi1c2uglqZjVlUjd38gUXHR6c/0PhUhTu4X
	c=
X-Received: by 2002:a05:6402:1588:b0:6a1:f93c:f0a6 with SMTP id 4fb4d7f45d1cf-6a38a997586mr14907299a12.12.1787059136149;
        Tue, 18 Aug 2026 06:18:56 -0700 (PDT)
X-Received: by 2002:a05:6402:1588:b0:6a1:f93c:f0a6 with SMTP id 4fb4d7f45d1cf-6a38a997586mr14907218a12.12.1787059135721;
        Tue, 18 Aug 2026 06:18:55 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3d8596ce4sm1792511a12.21.2026.08.18.06.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 06:18:55 -0700 (PDT)
Message-ID: <3f18947b-3136-4526-be12-08444ebb238a@redhat.com>
Date: Tue, 18 Aug 2026 15:18:54 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20260817232957.1281637-1-pablo@netfilter.org>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/26 1:29 AM, Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter/IPVS fixes for net-next,
> I am targetting this tree since 7.2 has been already released.

FTR, you can always target 'net' regardless of the current Linus's tree
status.

No action needed here just FYI.

/P

