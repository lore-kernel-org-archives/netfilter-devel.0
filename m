Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6591607B0
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724252014; cv=none; b=IszzZuaRv60ZswQJd16ta7FhJ8y/JuWGSE9tw13aWnjBDHOTNdIq33gC1YyWuUAdeEVCMyrrOgRz1P25AGLec8BQPL02w2HWQv5S2i5vOeyNmOYd0B0dGZJdGazfbsSV2Y+jU5xLs8mMco0NIMwX4l12SFb2oUSaEHhJ3iaFsQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724252014; c=relaxed/simple;
	bh=QRowLw6jeaZM96Gx0RTdiyjBbs/u63cqCTb4+mz3jVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMI+QFcM314kbAABPfhUq/GzES9C7dx+iYMEcf3GE6dwaeKoMtB7ua9O3yN6orubm/2q9ChL2Ns1ZxeEiG6KnEPY+VgEmMMNFVHXUynoClUFQEIBnu21jk7JIl7tbjXhFgr73daU1WzHuRYTmItp4+Uv1omI+nIMNj+Suu2gv7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDuaVkYW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDuaVkYW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724252012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QRowLw6jeaZM96Gx0RTdiyjBbs/u63cqCTb4+mz3jVY=;
	b=ZDuaVkYW9ebhghUiNuCuqZJyS7A/mV8zB9NP+pdRhtVsAIgknpS/GM4+lJGLvbs4eM8WG7
	O0sRYLyfkWrb2nwblkzNWWgL7J0DMKYHxU0TiAvqsrCgfuV0GgXQmdmm7iB1yjb+T08aPx
	Prhdapyxb+Omb2JXMAEKOvfoLiehW/E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-UstaoOjQPYWdeKItwleetA-1; Wed, 21 Aug 2024 10:53:31 -0400
X-MC-Unique: UstaoOjQPYWdeKItwleetA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3718c0b4905so3080931f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724252009; x=1724856809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRowLw6jeaZM96Gx0RTdiyjBbs/u63cqCTb4+mz3jVY=;
        b=sIIeAkBuBBAmkEyr1zW97l0zVXsMR5jyKjYms1kaao++x/MvmTMS7rW78Hvw08ZITs
         fchCZegE3ZkHtcBW69nANAN2twAq4gn459oZ2Vl3izaP7Nx+ehHO/yY4CzPott+m25wW
         n2b3K0bzD1OWXsCx20l0+4hQtgxABKWZ1GFZxmOPZ1FAG+S6+Vh9BdzRV7Q7Ik80WSKX
         DT7Rwdy+qVpa4jjtmGTS8nWiHdtrl7xFOIEWsObbeK8+d/HwPQUd3dDrxttL8cW+BJId
         SFbClbL8suLa4dXIz+w4yr1zZQpoFICHlndj3DKkKvph2DJGtKqIz0R6g5qxhpjJOnEf
         5oDw==
X-Forwarded-Encrypted: i=1; AJvYcCX8Dmj3MOpoVUG11k7os01InsvhI8xs5aGJ70y8JwMKrk+DTis+oyUIJXwdkPPmSiswM6blHMCe9T4YXti3T4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLlVBpLR57+9CZMgSKcMdl/mC1B7LRvPp018ccOmbe6+egzNvr
	zfhMI0c36elMbMcQftIZyJrHjXSQO0/eK4lEytq39+ORhcxUJwReOFMXn/0kISEKR4IewRTQvFK
	X+q7CF9OMVJn4enlEu8PstWogWhIAn2Ki1IHcV4VimSZ2+hZB4myr7KADc8BIRV/RgOZCeRellO
	S+
X-Received: by 2002:adf:f892:0:b0:366:eade:bfbb with SMTP id ffacd0b85a97d-372fd70ce60mr1529930f8f.46.1724252009418;
        Wed, 21 Aug 2024 07:53:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZDr7ggR+/eNYCST3LZgSsI550O5ufyI8DRdkzvxCJn3F00o3+I4ON3GXaiIZw6yjPzdqQRg==
X-Received: by 2002:adf:f892:0:b0:366:eade:bfbb with SMTP id ffacd0b85a97d-372fd70ce60mr1529902f8f.46.1724252008552;
        Wed, 21 Aug 2024 07:53:28 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abed91071sm29081695e9.1.2024.08.21.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:53:28 -0700 (PDT)
Date: Wed, 21 Aug 2024 16:53:26 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 05/12] netfilter: nft_fib: Unmask upper DSCP bits
Message-ID: <ZsX/ZlsFqN3YnQ3h@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-6-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-6-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:44PM +0300, Ido Schimmel wrote:
> In a similar fashion to the iptables rpfilter match, unmask the upper
> DSCP bits of the DS field of the currently tested packet so that in the
> future the FIB lookup could be performed according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

