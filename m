Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE80181328
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723111147; cv=none; b=jp/4TSwpJEY+P8AeCONA26yPUrYiCovo1YjxHbI79vft1nxj3leHWXYDSJiumjphj/zlmhSFP4WhJEw16Q0O/7PwXLgQ8+IZvJ9j9NbCNAX3ocxFAHp4hkdbCW5mg90TCBfe2OTGmnfB4Y8x/A5W1LpDAGRjG4pvzVXQjmAJn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723111147; c=relaxed/simple;
	bh=CDmTQRy/J1L9W74tk9sXOL0HGX8nKrJJVV9IndgQNig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HGSWCzLuelB/+PMAc2tdAR1tuvI9hQyLrnvwNhtQn1lh73umiVfODyrLA8IbBztRQ13HCCCQNZDSFEJHd1fmm7yWg2NqFOooW8CpCFSRgtYxB4Zh2AMR/2ZmWJS6dd57BCxzjQCG1msxGBRNfsGQo1Tr/I4xWQejtee/SUIUACI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Ho1TY6Bn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Ho1TY6Bn"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-426526d30aaso5097415e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2024 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723111143; x=1723715943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl2pb6omKwLpJiwc2rBi6lcStWlQsJCXf94tdvIqSVU=;
        b=Ho1TY6BnvOE0UzNDWfNEepHgANWxfywRvckCbQEBmuHPw/F/ONDGG3Uotwms7M88u3
         VfU+rP5tpIpbW+8SpsnV1rgLITbvKFqmVi/kuaLpR/UKlUPaS9kBmocsrEFTuUD65IR/
         yKfBp8QJT38HLcUqLQiv+lQSOf6YfFH4C5vU719BurMReAvzd2pSmRJ4AzLybSsjWr5D
         M+3cTa1EAtlR1ZLvltyL83P0hOQk2b0D2LK37/ARWWnfROsfP8nzxXr3xaFoXL16ELKh
         95VU+7pihDlmH3beVlNpyBLNaSaDQjLMpJ4L8WR+GjMNBFB8PsxLCf+EG/n9Ww5ds3dG
         numw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723111143; x=1723715943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl2pb6omKwLpJiwc2rBi6lcStWlQsJCXf94tdvIqSVU=;
        b=SHl/HLf1NLaDG5mgD5LGgyxU9R7bCbMSePdwzKu9cUzt4LKzetv/G9Eet8swJ2UMKl
         PRVXlF+NgtlkXq/zOSd3sbIC0IoZauXJPXaKVc0Twpmu+fjxmZV7TZtlad1YzsNLKnpF
         I8TBxX6iHDqDOeZJVgFyzqjoIPLJk0tMFu49h/gxEnvFF/he6wzV9i0lmmSSgPdUQrCe
         09O11SstxDbXQDNHW1dK5kkfG3la44xY7zSV7X58bBJcwmIMkfap4NStNlOI+YN9VDeO
         Nxgr5WhpjQzt+c8Y7yBAu5w6eiYmtEIR3BfSYTPObZxTMhl/qx096lOq1tvYfEaVcCPy
         LLlw==
X-Gm-Message-State: AOJu0YxScRsmV/JRszIVWwS08loFGGagUzD96MsB3pjP+j63es6Vs/eQ
	ktEYP0h4TqU+x4AwdkUuW+K3kaJ/jbojQzZdV8fXJXdKCCLJv7eCIX5o/Q==
X-Google-Smtp-Source: AGHT+IHg+qCVuk50jlxxmvqg6gJX23cs/jVzDXYUqUgWTdNU3t0l/mhIVq6/5WqSrC2Xott3+F56Zw==
X-Received: by 2002:a05:600c:5128:b0:426:64a2:5362 with SMTP id 5b1f17b1804b1-4290aee0421mr10863095e9.8.1723111143031;
        Thu, 08 Aug 2024 02:59:03 -0700 (PDT)
Received: from localhost.localdomain (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429059a5b38sm67491295e9.33.2024.08.08.02.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 02:59:02 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: iptables: compiling with kernel headers
Date: Thu,  8 Aug 2024 09:59:01 +0000
Message-Id: <20240808095901.2844386-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240807162203.GA22962 () breakpoint ! cc>
References: <20240807162203.GA22962 () breakpoint ! cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Florian,

> Why are you interested in getting iptables to work?
> 
> It would be better to ensure that nftables is working properly; unlike
> with xtables the kernel representation is hidden from userspace.

Sorry I should have been clear initially, I am trying to compile using nftables.

> i.e. sizeof(unsigned long) == 16 on this architecture?
...
> No idea, I don't know this architecture.
> In iptables, userspace and kernel space exchange binary blobs via
> get/setsockopt calls, these binary blobs consists of the relevant
> ipt/ip6t/xt_entry structures, matches, targets etc.
>
> Their layout must be the same in userspace and kernel.

An unsigned long is 8B, which is why we want to use it instead of a "*", which
is a 128b capability in userspace, but is a standard 64b pointer in kernel space.
This is what I am trying to achieve; to maintain the layout between kernel and
userspace. The layout will be the same in kernel and userspace if unsigned long
is used since this is fixed size type to kernel and user.
Since these spaces in the structure i am modifying are reserved strictly for *kernel*
pointers, they should not be used by the userspace right? So I can safely have
userspace assume it is 64b and it will be okay since userspace will not try to
dereference what is stored within there?

> If they are not, you lose and only "solution" is more crap added to
> CONFIG_NETFILTER_XTABLES_COMPAT.
> (The reason for this being a Kconfig option is because I want to remove it).

I'm not sure I understand what you mean here. Although I have noticed the
compat functions in the code, I could not make sense of how/why and when
they are needed. Can you explain the use of this option? I guessed they were for
xtables/nftables compatibility, so they will not help or are not needed in
my instance?

> Not tested, looks like it no longer works.

Okay thanks that's good to know...

> > What I thought might be a solution to compile with my modified headers
> > would be to simply copy over and replace the relevant headers which
> > are present in the ./include/linux/ directory of the iptables source
> > repo. However, even with unmodified kernel headers this throws up its
> > own issues, because I see that there are differences between some of
> > these headers in the iptables source and those in the kernel source
> > itself.
> 
> Yes, but this is unwanted.

I guesss fixing up the --with-kernel option to use the specific headers from the
kernel repo (in my case my modified ones) would be a more sensible option where I
would solve my issue, but also be able to submit a patch that might be of use
to others?

> No, its just that noone has done a full resync in a long time.
> The kernel headers are authoritative, but I fear that just replacing
> them with recent upstream versions will result in more surprises just
> like the ones you found, which need to be fixed up on userspace side.

Okay. Well I suppose if I have to do this for my own work and I can fix any
of these surprises this would be useful?

Many thanks,

Josh
