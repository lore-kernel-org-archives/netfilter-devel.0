Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478FB1386DF
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259019; cv=none; b=Bhgsb3Hdso+GXjdl6XPSbIr1iM9IsYw5lEYZAjk2w6JMT6ctrtL9UWOzG03/E78DFt4yR/yBACQA1j7P5zBbpskkptjlsKkLk3rxlIOvbEJXBiORJgoFeegklCzwbsf5+E52/cf2nMz3Kkdy9niMEEWbOAaS40n43cbFI5Qn+yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259019; c=relaxed/simple;
	bh=0kVY1oV287jCseyCWC/1hEdI8AU8MwdYoInIdn6qdok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCQ/2wXSh1TjKNVMMT1F498cYujQ6Lnz0ibrH8n1a/tl2/8H607IyncDgeWqosetxA+zYBantHqAbPlI17MYriB6ZiuoWGfvWVaYXkcvNQAyyz0GmPQ07CpkgjcxZ3EO3iUttdT9UkI0soPDDBF7X0v3ZcWftZoBEJnSO1nf2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HF54EQzJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HF54EQzJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724259017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0kVY1oV287jCseyCWC/1hEdI8AU8MwdYoInIdn6qdok=;
	b=HF54EQzJVSPEaG1SxJglRqmeMx2Cz6Pt7yPPg6dNcIdz43fi4igIDZhmd/zevOuwyk0A8m
	Gyh/NsUVLkhUqLbqf6tI47P69KfRG4RixItSZxKgvrjpsUIpf4w4O6e3sP/pgu5EbwJaDI
	6lja4AIjiuZ1Ioh3eYcZXsSK+aikAsc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-2LZMPPFIOxaBbaZGhBUIjQ-1; Wed, 21 Aug 2024 12:50:15 -0400
X-MC-Unique: 2LZMPPFIOxaBbaZGhBUIjQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4280a434147so58073805e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 09:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724259014; x=1724863814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kVY1oV287jCseyCWC/1hEdI8AU8MwdYoInIdn6qdok=;
        b=EVgFB78AJQXb2IroC/WXjpDd/F77VMtUecRKQX87Jge9+GJn9Y2bQ4P6Ss3Zgw2tgm
         pIDYygYScfHZgiejbvY8nRLkNqudqj8u+75r83+mt4wOfqPQ3FmQv8ayCqkusYkKLMM9
         Wu7ZN6pTwJWRgfND4vN1Sa/WFj1j3YLWjPYESlHd24hWxfzyiPnYtOtsAb82o5DGGiGM
         RZzTn7YAexFXM5nWGG5f7i0ggzHCX43qN1qOmz2s7/TfFVmbcmyKrsp+dQ1xguJHFxIT
         RNNJgVGXz37x7bbyz9r6MyrXO8YC5fg5teo2rXJzTL76UNe/uFKwI69cjr4U/GBnNWoO
         FSpA==
X-Forwarded-Encrypted: i=1; AJvYcCUITEZU4UN2sjX+ria+E0cplGqJjIAzsU2ZZh4J8y8aTg0XYmSrFdCoLrL/56SHKE2FB3b+c4TYjDKQojeRAbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YynjBpnVrlkJlvN9FNhjZF1dTvGHSnUgBJHw4FSg4vzRVl7etJy
	9aTDVWmq0IF8/RQZ/1T3Ouwtv9UEALRAlw69DzaqYpCof7HmvgVQ2oySxa/2GjZ6f+Uzq+ZLdLV
	7+lob889PFeOe7r0x/pGLePCHyXtUTEXlVGLvFyYTa45aT0lv3FDZPLvomgYhEExooQ==
X-Received: by 2002:a05:600c:1c90:b0:428:2e9:6573 with SMTP id 5b1f17b1804b1-42abf05ae37mr18604815e9.17.1724259014586;
        Wed, 21 Aug 2024 09:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpdYw76zuZe0YDI3B1kYguVY6tpjojxF2XLFri0Dx6C52Xr5OcnHJXIat12lugoEB31B+ySw==
X-Received: by 2002:a05:600c:1c90:b0:428:2e9:6573 with SMTP id 5b1f17b1804b1-42abf05ae37mr18604395e9.17.1724259013301;
        Wed, 21 Aug 2024 09:50:13 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abee86f23sm30360345e9.20.2024.08.21.09.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 09:50:12 -0700 (PDT)
Date: Wed, 21 Aug 2024 18:50:10 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 12/12] ipv4: Unmask upper DSCP bits when using
 hints
Message-ID: <ZsYawgBS7HuvFmMR@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-13-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-13-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:51PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when performing source validation and routing
> a packet using the same route from a previously processed packet (hint).
> In the future, this will allow us to perform the FIB lookup that is
> performed as part of source validation according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

