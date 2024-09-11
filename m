Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92341AB6EF;
	Wed, 11 Sep 2024 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068359; cv=none; b=hTSEQDdGPynElhtCfGqSuELXdVMa8lMIOqjroO17to0ajYkCgHYo31mEoauJVV9apwGU4dJ8r35YkSLLSynejvXvZN5WaMwNWUuDHJFFbWUzGnKJ44bFlOyseqyPtPeYXxWoFE7+Chd8TDVVvTJnsbSJc4Q03zoahxJcn4uE+Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068359; c=relaxed/simple;
	bh=WAoc2RISsQrKbZgJ6XAWf0pR1Jdg8jts/oxYW6s/O1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tB7fPSyjVsWg+avTbhKsYT68O9wdE3++OE4GymzkZN9x9siQH1S0NfqOIyGsUibDZD2tNIlXFuIjOoLdkUAzk+/D276UNX38yfGl229zWc1J27E5yVTccn+kndp9h8gulejyaNjeU4ifZ0Ralp9QWSDGQGwANPSzqYaa5XaYm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8a6d1766a7so266056266b.3;
        Wed, 11 Sep 2024 08:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068356; x=1726673156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAoc2RISsQrKbZgJ6XAWf0pR1Jdg8jts/oxYW6s/O1E=;
        b=oeoVBE1LgU62nFyyRLkF8Xu8x2lbe1P5U0B8dxwXSIYMqGeYb1avtP5pH8TPhC0Y/l
         q1tR9ujQdx0goMrfeyRPV5+/3CwVEqaQgWfA8vw+q7qT3tbgRLk0ykR3hSPLDMAkjXZC
         6IVKvNdERkMS+DLZMrPhh/1iE26qqE+G333WhGUVd+2CetI6zwWU3RwDNqiqDJAABR/r
         1LeUzFPqaa+jZ/wPpXkHdezwLhKzBH/AcgweG0Yy6I3k1JoJ9LVVkGh5ukgVOSPsGak3
         zpCU7U7JcouKpFq8jtjwqQksw0Rq0aPd62rt6dAC5fzf3kXJ/EKgnM7cbGSLv6Rz1z63
         d4tg==
X-Forwarded-Encrypted: i=1; AJvYcCVDgkSqzVOAYA68J8fhbyPPGUylCK2uvayTRHQHpQL3aKZhJtD4NkCu6Ta72WNbG6u26ZpRhipW@vger.kernel.org, AJvYcCWhKx5ps9czOvgFuMRG/vuk5tqUI6LeXMjGJx0A34dJroNXoeCFQ1WZ6WDDTETsQfNxnLbMpkao4NZUD3Q=@vger.kernel.org, AJvYcCX1hEwVrIUYYMLgAyw1gYswjK5VOX9tJMGemb2U94pNEOM7koHCOXxAGHsP+MlUKXJhuxEmO/3PBP5UkzmgyHFs@vger.kernel.org
X-Gm-Message-State: AOJu0YxcoUnShp/fj/O0sYELKnqEWdcB+xLjSV40kXJ4W1In6AwZkLt9
	hDJ4wsfnE3eYMr4y4ycUcSJgLxYFvIsQPHTMkFau1YgD4QIunend
X-Google-Smtp-Source: AGHT+IHAztH4opqQG2DTsdHzLxdkUe6JGiqTpl6z8riTbqjrKOXzt7FVuvFYh+qdz/N1Ug8r91/MTA==
X-Received: by 2002:a17:907:60c9:b0:a80:bf95:7743 with SMTP id a640c23a62f3a-a900474562emr332798666b.13.1726068355293;
        Wed, 11 Sep 2024 08:25:55 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c624d4sm616997466b.112.2024.09.11.08.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 08:25:54 -0700 (PDT)
Date: Wed, 11 Sep 2024 08:25:52 -0700
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, pablo@netfilter.org
Cc: rbc@meta.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240911-weightless-maize-ferret-5c23e1@devvm32600>
References: <20240909084620.3155679-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909084620.3155679-1-leitao@debian.org>

Hello,

On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> Kconfigs user selectable, avoiding creating an extra dependency by
> enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.

Any other feedback regarding this change? This is technically causing
user visible regression and blocks us from rolling out recent kernels.

Thank you,
--breno
