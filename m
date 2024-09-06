Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DEC1C86F5
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621310; cv=none; b=WZq4QP76N7klfCX7aLXIbE5Lv7lzyWWpujpVjJ2HZUiRSFAedcT7qQHtzzj4Re4Ncly44IuC18E36650Mc4AornA3spmtnKtvLqwEx62d3XYz3lmrkW89+MxSL+y/QrmMEQQ5FFXi2HFNDdTzEkNHSS6AF5fiC0NaRwOSX8I5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621310; c=relaxed/simple;
	bh=0NGiB9JCDYS9eHATqhHJptO0ZudgwqWhSFOBgZQcJOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCyOlhxzfKP62ZuXQr6sgX9FfIf+ptQFjr9MR3FwbyAw/WS7gHmcJY2H8jxjnEbxfW+02nJ74Q/B3Q44p2ZskisN24RQ6SiX40/KNfcr5tg1cbaNgf9l39RFjIiQ918LEIkvIY5InDj92tqwtgbXaOV6VQxGo1SS/cYujpVIqRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=COUiHW8E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="COUiHW8E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725621307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0NGiB9JCDYS9eHATqhHJptO0ZudgwqWhSFOBgZQcJOI=;
	b=COUiHW8EvBM6PoV4HjoARUgXVCG8XhghMBYGkt0r0nkt/WuKC5Q3CTlQyr+RCtHgcbjBgY
	ZtfR4o1fq1mzsM8cOEusxr2Hnb07KxNSGoM/kMZ5zzcNRa8JSwMVvYdMWJKfNyAC/fDtDm
	i0MaVoPHx7tkih33Xod+z8+RYIglaDc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-x3Iu7smbMSCqQI45IVoPkg-1; Fri, 06 Sep 2024 07:15:06 -0400
X-MC-Unique: x3Iu7smbMSCqQI45IVoPkg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42bb9fa67d7so19345255e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621305; x=1726226105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NGiB9JCDYS9eHATqhHJptO0ZudgwqWhSFOBgZQcJOI=;
        b=vJMR1qsOUKDwlbQAYQ+Y33TZMaVBRjNNuVutsve+V8dYYivPRmiOmkwAX55l4Sia8u
         qaS9+QtPwPpm+VO5ZBU6Y+AD45vRJ87fCzMUKO+M9MUcMSkXzo1pEbrSrd49z3CyjtRi
         pCrEhEqCGo/Sy+Vecfh6ess/PjTZyjuNWlJaSMpclwJjv13kRL1hD5h1fiT9aHNSEEyD
         7ucbyHe6ohtcsbpSb2fqKcArSwRQFsDuSKhxf3eWoXXYBF7FjzeMZJeLqUSadx/QpqML
         t2dSiJXgECKjV69GWh2esDvfpmKh+k+Xl73VqwUAMPN1tdsKt/xm5h5CV8GGCAyzPOcc
         Al0A==
X-Forwarded-Encrypted: i=1; AJvYcCUeo+12G9LSqf+5QYkb5r/FrJbeD5z9cEZhG66SjzcVWtyx1dmv1dP1knwLQf6K77g6YzB0arGT7fy6mLCs5Go=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhj9IVkZANoZzlmKhuhXKN6VELNDB/z2/sL7bjEm3hLcSM7BTT
	dihwW3ztLlj/nFSar+HyjKyttn2RK8rjY3fcq4+AKP6l0gwXKWhGUN0GypoeSM3eYgZr33kxfET
	L2kniX/FXZkQ21IZ/4IkAMr2+Zn/5lCUtfEbvANH7U9LH+60I6PsfR0w3s1evnPl4Pw==
X-Received: by 2002:a05:600c:310a:b0:42a:a6aa:4118 with SMTP id 5b1f17b1804b1-42c9f98b4aamr16076065e9.18.1725621304844;
        Fri, 06 Sep 2024 04:15:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7vCxT8H4VqHEs2N44xCaNM+DluDvFbOAReI6BECcPwvJ8SnS7DtqOd/aYseydN9zLNtq3KA==
X-Received: by 2002:a05:600c:310a:b0:42a:a6aa:4118 with SMTP id 5b1f17b1804b1-42c9f98b4aamr16075695e9.18.1725621304232;
        Fri, 06 Sep 2024 04:15:04 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca8cebd35sm660405e9.0.2024.09.06.04.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:15:03 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:15:01 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 01/12] netfilter: br_netfilter: Unmask upper
 DSCP bits in br_nf_pre_routing_finish()
Message-ID: <ZtrkNbZcjQrUmdcC@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-2-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-2-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:29PM +0300, Ido Schimmel wrote:
> Unmask upper DSCP bits when calling ip_route_output() so that in the
> future it could perform the FIB lookup according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

