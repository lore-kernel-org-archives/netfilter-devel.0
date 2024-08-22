Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D353168497
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724349324; cv=none; b=gj0/OG/F+3QordBJtx3fZgfYXACGrxBGTI953uWs/Czm/HHVa1fenOtD1QvNKJcGaMMPUvjB0YSwpz3OnSsTfDGsA796Z+TQpt5Ko1R9b8v+5y3XVaJ7C4q5zQ8EgNtJdKmVlohrln8EQYRm1nXGBV14ek3d5zY84mfyUmOB/vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724349324; c=relaxed/simple;
	bh=0XcIa29OoFfxsBXltwQYVdzr1GiMVSDn+ts+9lqnRO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPl1sJmckB1oMTqs8xKVJwTX26yzdfZnXdTJQv3ecnXzv/0VjCvlMqUDY+Y1RXkWmfyRyDerYmKcOFCcgMcvFJ8PxodLjoQCZ8gWkDocKFS+uHxogrixNwkvitkgToX58bBhJAUEnLyoIGxOEIBuml/kJYBNwQo8vFhGL+QkJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a8666734767so138788366b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 10:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724349321; x=1724954121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWTrl+LdPGz41UsRvCotEZGrzpgKAQwzb8p0dsCSnO4=;
        b=p9JiHKZnz+b//GwWFvb0x5ao+3VhYRDEN+4fKBzK9Db1O1Hx99HBK13YqRYXJj5O7J
         9q8Ek8SLeGH45s2ntpgCs86ATRJ44u0E+Okpb7vPr18P4CjHwUAMBNVvtHo9i14xZMHf
         XzJswDOe/6bGoW7QKRkme9sHst/Kng3J7hjLXqH3Nn8F07agL0Z2bn7Cb9LRwnQ6QHTd
         09T+xOQxyNtpWPvptq1TDDdKmI+wLW3jXi7eCAVz0mVmGwCSJEb4jzpu14RSRtqSUt3K
         hqtvYBEptMGVu0J5+DLTZet5NzQ0r7jNL+awery72bujxvpSl47yz0I4tdDEQ87Yheel
         sOLw==
X-Forwarded-Encrypted: i=1; AJvYcCXyuAwbzMsI6UunvkKw4zv3E9saJsLfblYdqzqSyROfPVE5PCyZwUJlX0Ns7St+eGxGweWu/r9xduTD3W2lv40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq78DyWz7qR1WIl+X9cHIszctMu3JCLrYa+fRqN8Mz0Zh6j8nz
	WQc0Uh9xeGqfoEMozzQM1Te4VIQntuYW9xe0rVvjhcqkx2lVeXT98+A+DNmY
X-Google-Smtp-Source: AGHT+IGGU/1GpHhd23Zu7DL9e4lAv/AKcNyJbFrPqzacgQRisJhif0aWJkXLZWX6XrLOHd+2MaBaYw==
X-Received: by 2002:a17:907:9490:b0:a7a:a892:8e05 with SMTP id a640c23a62f3a-a866f359158mr512936866b.33.1724349321027;
        Thu, 22 Aug 2024 10:55:21 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-001.fbsv.net. [2a03:2880:30ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f299d51sm148107866b.54.2024.08.22.10.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 10:55:20 -0700 (PDT)
Date: Thu, 22 Aug 2024 10:55:18 -0700
From: Breno Leitao <leitao@debian.org>
To: Florian Westphal <fw@strlen.de>
Cc: rbc@meta.com, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: Kconfig: IP6_NF_IPTABLES_LEGACY old =y behaviour
 question
Message-ID: <Zsd7hk8SMQoHKjwR@gmail.com>
References: <Zsb+YHrLklrTCrly@gmail.com>
 <20240822112339.GA21472@breakpoint.cc>
 <Zscy83HM2TlwkSDq@gmail.com>
 <20240822132022.GA25665@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822132022.GA25665@breakpoint.cc>

Hello Florian,

On Thu, Aug 22, 2024 at 03:20:22PM +0200, Florian Westphal wrote:
> Breno Leitao <leitao@debian.org> wrote:
> > On Thu, Aug 22, 2024 at 01:23:39PM +0200, Florian Westphal wrote:

> > In certain environments, iptables needs to run, but there is *no*
> > permission to load modules.
> > 
> > For those cases, I have CONFIG_IP6_NF_IPTABLES configured as y in
> > previous kernels, and now it becomes a "m", which doesn't work because
> > iptables doesn't have permission to load modules, returning:
> > 
> > 	$ ip6tables -L
> > 	modprobe: FATAL: Module ip6_tables not found in directory /lib/modules/....
> > 	ip6tables v1.8.10 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
> > 	Perhaps ip6tables or your kernel needs to be upgraded.
> 
> Hmm, but how can that work?  If you can't load modules, you can't load
> ip6t_filter either.

This happens inside a container that has no support for module loading, and
expects the tables to be =y.

> And if thats builtin, then IP6_NF_IPTABLES_LEGACY is supposed to become
> =y too.

Correct, both of them (IP6_NF_IPTABLES_LEGACY and IP_NF_IPTABLES_LEGACY)
was able to be user selectable, and they are not anymore, causing this
behaviour change.

Thanks for your support,
--breno
