Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D315B1CB32E
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621413; cv=none; b=W3nfTWDV+VAYJpacqzYaUPzpxQ7w4H8fzd6qQWNoPBBAgZebmnzHV+WzpC7tY452GT1t/Ek7ANtzAEVydtGF1TVN1B2iZfT1WFpnPksCp7hIMPv89SU9pFYcJP8053rKYzbycm61ECYE/sNXGPjEW1TCa+tWvKiijXDt3tz43mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621413; c=relaxed/simple;
	bh=h7oWCjCNEzwxWkQ6zm+j3DwBqzjK9b+0icEOnxXwUl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjMrrL44Tb3V3iXrZT/ZeRyqCj2dQZsRoSZ97gstZLEyw8sOci9XMNokgREaG8NmRjfKerlV5y7xXrdhWWj1ivP6GNYk/v48ecjtzmuIL9kyx+Phy9IVkAliqqzDnnlBHiMkaihrxHAceoIZCWjAbrTIHb2eXmRHe2zXlYM1jnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P9IpqXIO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P9IpqXIO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725621410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h7oWCjCNEzwxWkQ6zm+j3DwBqzjK9b+0icEOnxXwUl4=;
	b=P9IpqXIOYuPMear7iM/GeJVw+JsOv0jK+iYc2E8/WScE5VelG5B88eHP4LGN21kZGyZ/0S
	0t6GSwMNF5GUTcuucFC6ajmk3lsyBs/CwK9xiom914CNN/DiNwnXUrNX3OdgHKeSmUZDgh
	tEwOy3qdWvK41iM3+FtNYUqg53tpTOU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-AAYsZ1BLMx-djfJarTlbnw-1; Fri, 06 Sep 2024 07:16:49 -0400
X-MC-Unique: AAYsZ1BLMx-djfJarTlbnw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42bac946976so15431205e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621408; x=1726226208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7oWCjCNEzwxWkQ6zm+j3DwBqzjK9b+0icEOnxXwUl4=;
        b=EMHhvnLK5T22TNSnN7wl9LWpq7MbbCcvVwxiAbLdZeOqkEuC1bEj+MFp7EC1OxuNZv
         9bRkMZY60Tt6qW6AzKK+P9R2bj3dT3hDoqOvCSqsO0bk7p8eHNyoXGT9Eg3cIID3eucV
         e34+OlZz5gKGIqwvYYgy6/JfZW7IEYeeSbQlQ+INdyDogc9XsUW7055nu3R4JKeRMs1K
         ANHpfcIg31bJ9f2tAkaK1T9ckY4x77Uu/d58pSBey88LrQsIj/yYRwpcULtf/F+tVEh1
         0TKrUSURmsGtnXPDiOJmy0MrjDCqLRYQw3W3r/1JLXRltLV3o1IYYMf6w5FH2dsoBOxr
         gYNA==
X-Forwarded-Encrypted: i=1; AJvYcCUkaDV4f44oEs0ILHHRrnuS+E+i4GLRyDXTioQRe6UMWIDgFD4SuLNpzYvYfbTIsi+W9CfgM7uymJHkBfSo8Ks=@vger.kernel.org
X-Gm-Message-State: AOJu0YwATjW4MXeZGJDJylnJya/Wul1231IU60xS5AJDNWO+efs9w41H
	VsWXIzU9K/qxfGMdbEB9dDQSMOXuy7nGM2E1Hk+i7CPsspT7Blw3KAWHIqGLsZmosZeF0MFlCfu
	CpQLb9mTsOpQckk3qIFTEF8uSOfJY4aFxgla6gh84l3x/1ApRXtbtMevBvK3oemRDHA==
X-Received: by 2002:a05:6000:50d:b0:371:a70d:107e with SMTP id ffacd0b85a97d-3749b53169bmr20678065f8f.6.1725621408227;
        Fri, 06 Sep 2024 04:16:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPw/OgFFvEdcRZzS4cx+Sw6c3PFJDCcVrZn3G7jew1sCdpWo1/ODYEzc7WVrWFytZcY3xxPQ==
X-Received: by 2002:a05:6000:50d:b0:371:a70d:107e with SMTP id ffacd0b85a97d-3749b53169bmr20678030f8f.6.1725621407632;
        Fri, 06 Sep 2024 04:16:47 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4981asm21687261f8f.24.2024.09.06.04.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:16:47 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:16:45 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] ipv4: ip_gre: Unmask upper DSCP bits in
 ipgre_open()
Message-ID: <ZtrknS7zKAKP6g6l@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-3-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-3-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:30PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_gre() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

