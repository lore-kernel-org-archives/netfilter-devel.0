Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EA1136E37
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250951; cv=none; b=p7NXLMm2TW0pVhJiKcXDxod4xLh1AG4O1U7ZxU54awyDoy/DZ4BAdEjWsBmnuohEAG0o2A7DgEYTpy2EB4SQXG1h5u+iRvUR7Z9T/OWW0B6Ix+frtqXXBY52LbyL7dc4GYgDXxedCcOVljgfNnM72qX4QBXD8BTDasKaan2gcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250951; c=relaxed/simple;
	bh=phxy8Nt1OqlzmKYCd5FABRPmYnLA1V4MuusvN9MrHXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4WYxrUGJHPvqPkWZtj3zcmOgWtR0o9pAGf5gsi/lIHwF4iZLNmum6uVdjDz2dlbC1Yd1Tn/BBzg7E5WzLXDZp4TZaOxNN4PAy1hJLtjeSA2Pxte2Q1DjLNgAJKPQl7RA/Z0Heap2KlPCthbp68TS+S4agUT57qxBPhSvcursw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b51gNStE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b51gNStE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724250949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phxy8Nt1OqlzmKYCd5FABRPmYnLA1V4MuusvN9MrHXA=;
	b=b51gNStEH2hpZGOlwIU8cTQ7lXRT5bNt/BA1/c6vbwoCefFXNbBI0n9DWZ4dQ9TYJCqG81
	TqGotOeDNWoxhM1PiW2Y2vlsCOTNvSL9hc/Z3YxO9a5ztVawvt4ZWdzyRMs1m+nX0QxxmN
	USnZnfClNYm1PZWIrBTbgcn3UODyAHY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-uqkEiu6EPKWbRVTAaB3_6w-1; Wed, 21 Aug 2024 10:35:45 -0400
X-MC-Unique: uqkEiu6EPKWbRVTAaB3_6w-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3718e1d1847so4055304f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250945; x=1724855745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phxy8Nt1OqlzmKYCd5FABRPmYnLA1V4MuusvN9MrHXA=;
        b=AUksOFyrc1XwQ3qr/hfciNJojA17pd0z4nh4yZeVhphU5t5GFRsqS6D0FRL1Dlco5Y
         N60oEtT/SYEUcaF0+L9tiTyO52pbhA8GnUl7ngmW9POiR5EsV9BcEF/uoRPrz3fnUCsP
         o3H6LcJVussIEQ5/6YdWrSLNaKUIOyn1Su1IzIyz2EIajeBd4KUIOg2meoDy7iY07Kaw
         O2z2zn7qBQIqbX2NHCECr41p+T3JfMYMTSF0xiiQU8FSfdpcJqJkU4FsZ3sJvnooQoav
         g4VHsX1NszZqFmXTu/QyTBdQIOK7Oyu3dmOsvWMCWoS+Q7YDZYLVNdsB9tztEUcuCe6c
         c5Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUYVo4XII+Gdct/UP787bLGnHLUxu/iMYwLrqXHHSKNyTdB2QcssZ0cR/Ykb0AYrUHUQzPLf3BOenlX5Wf2CqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFgm8SUe7aYylj3MnVhu0EiGZ0VDPhzdVdakONtteOTiPmk1L1
	JjoqFx1AeBlM4oz/H58ieybslngEmzcDDBHojQcDtPAlQrbqzLqf6OzkwSudcU/jX6qUlvyvHrB
	VxUvMIlvZOuE7qiLzbp0Jljp974nBBABo6U/dUCTVrbKv82jNPiNFr7KKcc30u4dVvg==
X-Received: by 2002:a5d:4252:0:b0:366:efbd:8aa3 with SMTP id ffacd0b85a97d-372fd57fb24mr2452545f8f.2.1724250944648;
        Wed, 21 Aug 2024 07:35:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFguEF2AfMMWHH9u4at0L9cYsD4b608kMRe3EHd4+r93puOqWjRitnQ5PtgsiIk3CRcl7anlA==
X-Received: by 2002:a5d:4252:0:b0:366:efbd:8aa3 with SMTP id ffacd0b85a97d-372fd57fb24mr2452513f8f.2.1724250943820;
        Wed, 21 Aug 2024 07:35:43 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898ac79esm15887277f8f.110.2024.08.21.07.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:35:43 -0700 (PDT)
Date: Wed, 21 Aug 2024 16:35:41 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 01/12] bpf: Unmask upper DSCP bits in
 bpf_fib_lookup() helper
Message-ID: <ZsX7PQNRh+9Cz7ig@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-2-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-2-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:40PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits before invoking the IPv4 FIB lookup APIs so
> that in the future the lookup could be performed according to the full
> DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

