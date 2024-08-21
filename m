Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4C71D12EB
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724252815; cv=none; b=Kk2ocVYCSRDXpROXEHLD+uXSe5mfJLttpmB6M7jxHBuKn8SavXlvPFWbnf1JKXlq3AAre61vR8s+UG2h5s3mfGSjWhjL3d9XsrgUCoU2HInPtfzgGausxzjLWC6YfkcWx6cOsxg2FB3IkABJ8tiMWGARWNZ7cx50nbaFJgMFaoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724252815; c=relaxed/simple;
	bh=to97TeDicJXmAINHPIglAv1Z3AAxVgTCyxjcxwzQ+WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbUpZwCUYz1VvNS4CCUKphPL39IWqS64OIa+uFaBsoCBaEPicn+83ECqoZqu4qjVrqLH9W3952dJz63KklGJ/0H7MtyONWh+L0GEaEkaBNpONCdkXoQwOU9tfIXKVfT/5gDiG7COnGXspLpmuCy45PTCHHn4shkQrINxsRRrIc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=auDlWr9w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auDlWr9w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724252813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=to97TeDicJXmAINHPIglAv1Z3AAxVgTCyxjcxwzQ+WA=;
	b=auDlWr9w9EjKPccmk/N0969yXS+4ap7TQsoJrA/x7lOIQGHL21E+fLg3muxlTg3T52ilct
	9IURHxRzesC0njiCZwVPCO6FIRBSIYUoZMYaXk6654SxCxDgybHd9A6uY9HSE8HJtjYQvo
	+vzIi+A5ozXvRBRb9jybYSWcBddY4Hw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-Y-I_Y1tENcCIBJbQuZUlig-1; Wed, 21 Aug 2024 11:06:51 -0400
X-MC-Unique: Y-I_Y1tENcCIBJbQuZUlig-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-428076fef5dso57346795e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 08:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724252810; x=1724857610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=to97TeDicJXmAINHPIglAv1Z3AAxVgTCyxjcxwzQ+WA=;
        b=mXm28wmKqM6InUvFeN6ScsR49kVF84KeQ6s3xmqyfBRz9YhbNdJMEoY4s6Agr4h85C
         IhHZu0sNa0FtcAhHZnk8d0KL7HoRWWRsgANm2sUtM8cG34y3OXObpBxOaaSllAGwIH4T
         66wori+ORGy/Caa6H0HXno6rCCigacd3dTYb7cX2YFbwR8LRQMao2boyvAl131SS2G+T
         K98AUOJkp0DUR2NVuMFW2iV0DV4amf8uDJReQ+tN+HIoeKBsdhYaQ/ds2eyz1o+LN1v9
         PRqG5GAkpSE0mdJd2RKJRL0hhvqF2QL3rXWRUuYnG1FrKRPT1OWjR8uqFRhFMfA8B46D
         XTLg==
X-Forwarded-Encrypted: i=1; AJvYcCVtfIgLO7cyDdw5xFW6Hg6JlD0fuOQRF6Fyz+ogMlntr+E6zJW6M/iBZYXXZvbdF/BW8LKZajt9BmHfz+a7w1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ3iEP5vH932WX1b8arQN6K+g2FqGYtDr5CaEtl9Laao2DWAon
	4fkierFNqEjmQdJ0yl1jlf7o6TWxB6D0W5MOPqtOY/Gfd8gQ3xIIjyZXuS/5fYg6mwX0V2g+nfE
	8GJiGzhOwMMls5zrj+eaS56ThlMWeCoei/eLkGGafUi0pKWxWngUQ5IfcaWm9BVUuww==
X-Received: by 2002:a05:600c:3c94:b0:428:23c8:1e54 with SMTP id 5b1f17b1804b1-42abf05ba0emr18022085e9.18.1724252810622;
        Wed, 21 Aug 2024 08:06:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEiCsk9azLAavc2eGd1Zdp4wTY9+FLkpAEYZujUzgvcmE4b3AkL9yBV4AJjIH5CjD5eKxTqg==
X-Received: by 2002:a05:600c:3c94:b0:428:23c8:1e54 with SMTP id 5b1f17b1804b1-42abf05ba0emr18021655e9.18.1724252809808;
        Wed, 21 Aug 2024 08:06:49 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm29116605e9.31.2024.08.21.08.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:06:49 -0700 (PDT)
Date: Wed, 21 Aug 2024 17:06:47 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 07/12] ipv4: Unmask upper DSCP bits in
 fib_compute_spec_dst()
Message-ID: <ZsYChzAbHQzR8bX+@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-8-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-8-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:46PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits of the DS field of the packet that triggered
> the reply so that in the future the FIB lookup could be performed
> according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

