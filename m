Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89F280325
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704649; cv=none; b=otXGL6+bKTmITSMeij3RZEMTbAe4J1zbP+/TxHdd8hNCpudyQNEBcsYu1Lu8naj8Miar97dXGtoidovQb1pSqdp+JXaG2SS/NRXfoddAJHvdXM8GhqTA0wEvg0Mb/Zv0mcYAZTOUTtkWNew0apPI85ko1olGUsqusha3dLeQHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704649; c=relaxed/simple;
	bh=95yC15JbWppqU8jyo2fHbeAS3d+H0Gix7rRJptRWZtM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/A4HRlKFZBl1hC6p58KSxncggReg7CxJmz52okrX3B8OZv6qKU8w0zH/fNpM14Aq394OpfFgGdjn+wDGQ7agegcrdo+kCnaxvFDAFHWFhtKlh5w5lkP2wQ7LZnUD8SxSvF5lN83baMVoa/r8n6th1xE93oMQz69GI7T7/Fcoyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uo6DfEnJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uo6DfEnJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755704647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZTdOUMLElInOZa8jWVy+Dw5UJB8zui244DoqjKy0s0=;
	b=Uo6DfEnJdbhQcoH+ghQXLjF0uiogjSUIXS72VM1piO9sbxlm7v15B0NSf/Xw2k/opHjxQV
	pIjtLKqQrtKC+XnJ4RVHf9M0uLvuWkcA0AE5/F/d/B3euQt0kTH3RGgab2hq//YQh0uUNB
	onCh/Q/bezXtSWvRE2tIBju3V7M7AkA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-Mr164auyMzapD2VW5wnsMQ-1; Wed, 20 Aug 2025 11:44:05 -0400
X-MC-Unique: Mr164auyMzapD2VW5wnsMQ-1
X-Mimecast-MFC-AGG-ID: Mr164auyMzapD2VW5wnsMQ_1755704644
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a28ff4793so20989915e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 08:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755704644; x=1756309444;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CZTdOUMLElInOZa8jWVy+Dw5UJB8zui244DoqjKy0s0=;
        b=cRBc10Euet2YyNvvw7YphV+lI880cHgOO8NbG2TEF4KWH1tCV7M3/zbb5qXcZIhsRP
         TOdp7OiyKM/mcu2gAoYEthJOwoHh3G6+PrI+U68azTVmd8NE1MERyQl6gg4U6nfHIWgI
         0ledrZLIu2v+XleOa2VrtdNRLexPWJoPfwGi+qN+Q9alq8Nrgpg4dgQfD7sjWp+1CfSm
         lqz4wpb3m+gmijyc/NiuA6KDBCNGsXFWwLTRiSvEPS9yEMp12KTwLYm8po+l1F2cl3mN
         AKkv3EqIgvTGJFa6e1tH/lhWoWFThOwvROc5si5oJKXSoCmBq1LMoKn9+1oJbb4JGh7z
         cXqA==
X-Forwarded-Encrypted: i=1; AJvYcCUHBnZ2gaYzDmldDy7VTo6iaXkHvBaFt/wlubu+ZRmjnpOdek9XGutttQ1n03Ow3O8mlrSCR99B60AYEfJwd8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzymTedaNz09IrxLCpnjOTk2eE/Axl3SpC3LBZQPEUPZ8+1thq5
	1KDpECf7thVU+ivVw6bVlGaGYQYEFWh9Ys3J0Wad/4gX9mBnjNV4kZsvSCK65z4Tj69dS4DHDme
	KkUWhrayL404rhAdWk6U+lh8bN9nCzeAx2KbpQoTQckS7z+gAZUQgm8xQS6U/CHfiyx/2579kA1
	40uQ==
X-Gm-Gg: ASbGncuWLav23F8doePRnM3nEmSR6ArrLlqUYpqGjfG8Mf74CMjhhdHfIFq+xBpyYwW
	xrPey58fnU7WQ9xPiTOXzu9expdgwkQui689z7SBTFnFiiNZaU+QG/suLKlWQEiKWcjha2pfTq0
	CDxyF0LHdN6nN7b5yKdGBTY0v/voeD9qU8zq0J8Wd/up1D9ZRWS+fSsLXx7r+oFimln+DaaTjzU
	ujqvB02K081/HvAhGibEZnPacfK922gLXsPpS9Oh3uLR3ApuHrCG8XlEhRkbVkIEYEph9/AW5LV
	8kWdWJTJWNS5f3B3z1nEefPB6Z0Mq1iRNE0V2um3RCc3ndEvKLwujjgU3X1YX1jtv1cW
X-Received: by 2002:a05:600c:8b4b:b0:456:24aa:9586 with SMTP id 5b1f17b1804b1-45b479f7d79mr29730325e9.21.1755704643873;
        Wed, 20 Aug 2025 08:44:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQEQmzCV1NTmYWg14hpuYZBLWhYM2bdzJEG/AeqxOARbHWDkqg2ZXpbF4adP2mEM4l9ToKqA==
X-Received: by 2002:a05:600c:8b4b:b0:456:24aa:9586 with SMTP id 5b1f17b1804b1-45b479f7d79mr29730055e9.21.1755704643410;
        Wed, 20 Aug 2025 08:44:03 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c90cc4sm41236355e9.16.2025.08.20.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 08:44:02 -0700 (PDT)
Date: Wed, 20 Aug 2025 17:44:01 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, <netfilter-devel@vger.kernel.org>,
 pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820174401.5addbfc1@elisabeth>
In-Reply-To: <20250820144738.24250-6-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
	<20250820144738.24250-6-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 16:47:37 +0200
Florian Westphal <fw@strlen.de> wrote:

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The struct nft_pipapo_scratch is allocated, then aligned to the required
> alignment and difference (in bytes) is then saved in align_off. The
> aligned pointer is used later.
> While this works, it gets complicated with all the extra checks if
> all member before map are larger than the required alignment.
> 
> Instead of saving the aligned pointer, just save the returned pointer
> and align the map pointer in nft_pipapo_lookup() before using it. The
> alignment later on shouldn't be that expensive.

The cost of doing the alignment later was the very reason why I added
this whole dance in the first place though. Did you check packet
matching rates before and after this?

-- 
Stefano

