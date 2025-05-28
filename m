Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8365A322B
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 02:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399946; cv=none; b=U9s2qM9BTsojuzU1fxrIoqAlzn+tOcF2oR9AtTYhh9EzbuJTMvk+ycZuh/t+5gTMf/FFWvQ5rhOjFDh5ImUcuarg6mGQMC+R7S5SFmVn9vjxygMc5v0UiPsHDnguSZ/EKgqFi3vbCuXvsdScN05fNj2BYQhR1dtriKBbiFrXx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399946; c=relaxed/simple;
	bh=FenFoPDS+e4lFxaaYHrJYH6ntwqquZePchMFwTH2Jp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9d8ggOz+lmbLkheebSNbLhdg4uDeeoQA1AGjPy9svBcN1+Gq6NHjDMIrIF+KAEus32IvfCnd/h558oe4xiEA8w9dCca+DY+2b5PJrd4QAq2ulcUZKJq9AdCzf033IYUBq6tezStmXiLSVpKb8mEycJsn8DXWg1LAYXgNEP4nB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LScNVzWl; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LScNVzWl"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7cadd46eb07so385650085a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748399943; x=1749004743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FenFoPDS+e4lFxaaYHrJYH6ntwqquZePchMFwTH2Jp4=;
        b=LScNVzWlj8VFpOIey+QF0MOgJ/Zns9GhTC3lcnz9ruDkRObPigphfKQw4P0FVLmEiO
         6V7OGlNJVnYHuNANeIVdbtOUIrUAC0pgSGJUIKDMa+/1p3ItT23Si0yOfxhuwcIznz9g
         DK1/WdZ27qYliWxDKxfU8EU3njkkrMbePudzOsKKMPJ1o6l51qM9A3eSQPQsUxteOYk8
         KNYXng6pLwkoYCg4ZteOUqk0zRf4jqmDPyu2HRTOBJRUE7hSbc45Gj+7BGRJpKwpP/b/
         5haV9HLdpvkH6vkxUNDg2URn3EwieR78iBuCkETfI4e8gkPi/T86se2YtI0X78cQNve1
         3DmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748399943; x=1749004743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FenFoPDS+e4lFxaaYHrJYH6ntwqquZePchMFwTH2Jp4=;
        b=NWSvGGmJYwapmmD+R14b9l/FqT31nT77QL4iA6Gu93bcQJMeSbZn9ECud1kMRQOOjy
         bMrJzKLnKQyH42/3aZkVEZz6wkFySJ/LzwZpAGUsjQSb1FrXOQtgpHz/V+WB3aYgcB++
         Elpke5NqTfD7GlaWqC0BLP+OQRQyvHREl2Ijdt0Z+nk2UJSUXM9jL0eZMAwqeChOFPE6
         Y9b3vRA6fZX19jq2eFf7o7mN+KBwpEPPz4vwZOorcRohW0oAk4Wsw2T/01peitA6S7LI
         bYz729aJflQ2djPekqAS8G/O/bTYKNE1nUkmkNXS1r8m92VYVaMPKsu8wLIH+l6peERU
         iEOA==
X-Gm-Message-State: AOJu0Yx7dx/TZSU7e+wYH2KT1oub11rVoy0UZSR9J2SndWZs+QvTYXqM
	Cw8iln4dr7wDkv7Vdcmq02+y4nvvOIQ8r26F3qLFsBL6F7YoJzych89DDvhCsA==
X-Gm-Gg: ASbGncsgfCNGemaWqVPbibziY1ME7UdIan25lQhRZ9vEI9J12SmSIrYErQTNaru/i8O
	38doweYaMrO0Zf4CfD6YPzQEaik64y2xj/JcQEEEZo/tn4Oi8yOxmERg/gW4M//THODpQFBQ7oE
	bRso1S9iqvYlZpV8mn0JVlbUJZaB8qWQ9xpPV2p6yrIaIknu89KT8E1BZzfvXDa+1/dcfcgJc8m
	b/9tqlTXHs3/4UfrIYxLiODLs4FgNPFYUMZEuYV9EG3A9BFTr21VRXQ8sAH1exndCkbBqBayO9m
	r66VM1nglnWARQHrBD/k3OQjxe/Yrp7JfmQAOHmsd5DvsTYQ+jhlVfQJHg9Un+yBhjX2a/pJrvc
	ldsvcfoxlEMJVp8/Df6E=
X-Google-Smtp-Source: AGHT+IE13k8LaiK/smiY3DWugg6u2LVZd2oRtuOJl+cy4Jijp5xu4mMU1Pu+m45DP7p3UiRX2EuGKw==
X-Received: by 2002:a05:620a:24c7:b0:7c7:a184:7cb1 with SMTP id af79cd13be357-7cfc5d224a6mr74804985a.9.1748399943389;
        Tue, 27 May 2025 19:39:03 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cfc5d483ccsm17377685a.96.2025.05.27.19.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 19:39:03 -0700 (PDT)
Date: Tue, 27 May 2025 22:39:01 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aDZ3RUtjD3rHjgUc@fedora>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
 <aCxTJcL2DnSsquNe@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCxTJcL2DnSsquNe@strlen.de>

On Tue, May 20, 2025 at 12:02:13PM +0200, Florian Westphal wrote:
> LGTM, thanks.
> Acked-by: Florian Westphal <fw@strlen.de>

Much thanks to you for your feedback and patience.

Double checking... is there anything else for me to do in regards to
this patch at this time, or is it in the hands of the merge process of
the team(s)?

Just want to make sure no one is expecting action from me.


Thanks!!


SB
