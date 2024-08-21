Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0514F9E1
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724257714; cv=none; b=JVR0eFWI+8Idyz+OffdeQbd0ZBw0L5/RMRiQ9Rm3hubdhY8ejQLg0I5z70Gkim+rWmFQIBuHtv3RIlkZfBY1M1PE5Ge0TjP/3VmsJnpFyZFH6SeAyGum/stDxGBoHEKaXEs9H+XkMJK14R6IyzaV+Ogfa2ohXdmHJ3/cv+bfD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724257714; c=relaxed/simple;
	bh=INy/bAAJCjlbio1Ldw+aWgMzJBL0pym6HlFrkQVJuMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCZD0I/CF7WlHqhjW4WJ0Jbij2+khtKNFwQ8a1F9okmqIJuaOGqXM6IgdY2jj+13YG0jRAI4tqhkLkvT/E3XTthMOMyw+vmWMegB0LqREIXJIsbF4SMzxAhmbL57nSOvVheC291JOvLmMb4XBhHtvaJrGjWwY3d8dFGoHrnQTkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3uo23Xc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3uo23Xc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724257711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=INy/bAAJCjlbio1Ldw+aWgMzJBL0pym6HlFrkQVJuMc=;
	b=A3uo23XcGHfbnwJkIqbNH6Xb+FhoQhSygAGi5bEXg3QRK9yF5lE1FM08mQZjcL5z5Npmg4
	UKXITPhqcc2Ru7jedjsUnwHtcpe4+kZNwIRSwnmAxst9nps1ySqOSfA/SYiWiyCBUl6Qxj
	g3AFsAY4PN5+om9h1uf2PPtuKRFUzhA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-HyNmt79IM-GGi3J63A2RkQ-1; Wed, 21 Aug 2024 12:28:30 -0400
X-MC-Unique: HyNmt79IM-GGi3J63A2RkQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280cf2be19so56576455e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 09:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724257709; x=1724862509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=INy/bAAJCjlbio1Ldw+aWgMzJBL0pym6HlFrkQVJuMc=;
        b=DaFKhRLT59sEqkYabRWEXvmq2hMxKv9FrnDRxcZi97FZJA7sDZc5TEBm6ea8FZpa06
         YAtLSn3daLwXSYHSDDC6SwPNrLzAwL5yzsRZhPtx4IXDt+suCZ/bArtgP3kUMoWVskRO
         yI6nODqb2hsDJkofc6wGiqgl8HvJslSUHMkke9mkEpWN1bCH8UKYMTNpfUq8IZReycqj
         ttNF33hjCmNCD56ZR/t7syaGsRFJt72X69d4BojveUasq5Y5eDg7q6ohcPbArnQoXcIS
         Odi7BcJXpeGPkk3eLfTXC1YTCT/RpafPtbQqwEWztEKbhYUIG478d2T1ZSbqwASmwrjD
         kQcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD6fJqfJnFMmFJh35x8GWLKi2vCFadMIp5fOZ3HoJsdJh42j5+M5PSqYZRzQu0Niu4DF5rnxptx7nJQSG8/Rk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe8dma/m8qDg5uy9Ku3e7Su2XdpIqwjx3UzBqeqvYpH1dOpvup
	cqWepgj36G6uNmGhcBnvr0esJEhObO4s7KSOtJv4TbI6oJqcbbhR5DgkUhPfQDEvcGFckI8suSt
	ARQ6UDCn4xE2fYzO9gxuao4vR8B+mL3pn9wfIwIXbc1dR8zMfd0y4RNAL6LkJpDx85g==
X-Received: by 2002:a05:600c:46cb:b0:429:991:dd71 with SMTP id 5b1f17b1804b1-42abd22fecamr19431545e9.11.1724257708910;
        Wed, 21 Aug 2024 09:28:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5+n0Fv8HveCdgINXMy+eE22ChN3nWbNrpHxcY7XJtnEmbN/V8Dc0vDGGi9pP2zhZWlB17DQ==
X-Received: by 2002:a05:600c:46cb:b0:429:991:dd71 with SMTP id 5b1f17b1804b1-42abd22fecamr19431195e9.11.1724257708039;
        Wed, 21 Aug 2024 09:28:28 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abee8bd36sm30069825e9.18.2024.08.21.09.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 09:28:27 -0700 (PDT)
Date: Wed, 21 Aug 2024 18:28:25 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 08/12] ipv4: Unmask upper DSCP bits in input
 route lookup
Message-ID: <ZsYVqfPuyDiCyrO6@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-9-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-9-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:47PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits in input route lookup so that in the future
> the lookup could be performed according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

