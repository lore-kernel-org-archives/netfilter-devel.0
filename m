Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D20C345751
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673328; cv=none; b=a2+MXHmdEXugLl2ZpCZqZs5D9aUpBQVevlnTnVFknb9LKVbp3UgpyFW31VZPfrpWOKyn5iLXoep9nM3QP0IQnMnQinLFHNfVwC/aw2Mn55wFyGDQPlg9MrVC7/3FZiySAP9qRLwl+CPbFf36OIHwHSceLzcJEaH7sMYvyMuHRes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673328; c=relaxed/simple;
	bh=Im6VzXUuwdDDmZDQbOVnf4aGedh78bR8cSlODEcvMy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vb0x4c+tjkVkFn3QcPWh9ugFrJ5o6sjiy4AOu3b7+KFScf/rpi/gQpmnlIhPmeXGzq1r9YD62F4Wma/+nosfSjmrsUolkHzKs0WI97tbo4zhT38NkQqVVZtgCZqwsXWxfxFcl/YMGfezSB+ld5NDX/fkliP3JwNKZrqlvyayKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mev9YXuM; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mev9YXuM"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7a27c67cdc4so4998405b3a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761673326; x=1762278126; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXtwgLeN1ZS1AfyQjxZpzxTFmTVASzIiRqR3Osccy0Y=;
        b=mev9YXuMu+qGoKD5lO6M3V82corZbeb3NZfCrDXaH1LDRt4woQP5QwrwwbJkiMJfCq
         1twF+S2v6rhmhlOlGUwYLeGnaEM2/BgKcd3SNbx4fldJXXGfeRm3D2+pT7ZQkpVCQ1j5
         5oYGP1mEviDdX2A/lX6Al9kcOZFJriJIOIpG2hNpSuq0J/+TznBAG48X+99zpOPP4Nch
         4qTwLOqDvGsYmwmuLLlTNpLrg7hOyCh4ix1Xb6MojWH+dzoW2g3tZtbdmSKYBl2OoJsG
         yzjYTY+X9uvCpszPm5kUECSy29R0ARE52nN0Yy/IAbi2ho8QoP5bR5F49wrYMmZBoXJP
         6Khw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673326; x=1762278126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXtwgLeN1ZS1AfyQjxZpzxTFmTVASzIiRqR3Osccy0Y=;
        b=GOaZs6keh5DB3macoqfFcFhrtCiwQ8Vs6mziH/Cy+dXMuCrt/SUuhGlkKpQ0brBhLh
         VTOndEsISLzF7O5eqN7nvYI38vNlkXLA2gprV8AGwym7nFd2auTzqUr592D0TfLV3rRI
         VtDfLNcxmsuK9hcC4jdb8DzkQkDDCV+zgIfRKTVNrQ46HGDg+0q6n/0VMbkC0lf3lQjC
         6jisaMD52amAoamdS329I8oairMBUcMDMN2l3Vaw3nklM5QdzthKwC66qTqaCZgRqrhL
         oLE9VjUlnzfkrftD1VM4doUxDK1bQ1vBTYDPjlKLJ454Y7bwUvH92u+Ozc/XMhoonYjA
         f/Rg==
X-Gm-Message-State: AOJu0YxSyPJC4E+jO17Dhyo77Ycr/D7A2Ckangj9lAji3OFKKu0MS35o
	O4Y1B83tcTmEq0ymaJpKStwlrq9Qxs9xUuSMpLPtbcFgPMEgvCUVDx2K
X-Gm-Gg: ASbGncsoYez3uXzkPHWeSGaD6jNon1qABvnzwZxeMSeCkgxkfsO8aMHNPf5/Q/icByK
	lITWONMiqRHK2yXqSTZXZYVyo1r4An2dsHYV0Ins9ZkO2E1khrFYbFLfqc48rYhqG5vbhGTG2tx
	CTvucV+rBCnfyAlnXTZjDDxMMLKPRyXx3A3wE8T9WQUbYqFfi6g/uY6/L6kbKIrIcQnAN7aolbJ
	hXOnlvMIdfq82n6WJ1kczO2uitq9f93vQ0BYW6BsCyvXJqifJEcwPxH8R1uzXN/TyUtfChbNLE4
	hhqNPaZplrO64HDfQBwl02rGzJ0P/5b2NbheWyaNVWfdBnYtOuyfcMVidCC1NMQ77NtLGbgLXfc
	AU8oL47JGMVQ0iYsMw5hjInAEq+y7MeoxRVSB7fiMsIuS3CRu9U1T34H/IhFsAB1QmLexLYgSYz
	N2uuUvMYU1wCA0zCPOnNY=
X-Google-Smtp-Source: AGHT+IHY648HfWpg/1mCsYtX8S4x0CTFltDo3CpRCwoMSOqHKLBzLVsRp/I93hYx56RK6MNiNgUYAA==
X-Received: by 2002:a05:6a20:2588:b0:341:84ee:7596 with SMTP id adf61e73a8af0-344d228adf8mr5688460637.16.1761673326191;
        Tue, 28 Oct 2025 10:42:06 -0700 (PDT)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b71268bd810sm11197981a12.6.2025.10.28.10.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:42:05 -0700 (PDT)
Date: Tue, 28 Oct 2025 23:11:56 +0530
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v2] selftest: net: fix socklen_t type mismatch in
 sctp_collision test
Message-ID: <aQEAZLv8V0asoe4r@fedora>
References: <20251028172947.53153-1-ankitkhushwaha.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028172947.53153-1-ankitkhushwaha.linux@gmail.com>

Hi, 
Forgot to include changelog section in v2. 

Changelog:
v2: 
- formatting fixes compared to v1

v1: https://lore.kernel.org/linux-kselftest/20251026174649.276515-1-ankitkhushwaha.linux@gmail.com/

Thanks
--
Ankit
