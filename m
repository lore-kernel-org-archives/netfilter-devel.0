Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681C035EDD7
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770913455; cv=none; b=pp0irfCtv1ieP1NKbQBD7GgxvTwCVKyQMC6D8eCNanPAg0T8lWnwiMw2qWehFUiyrL7JvPLEVr/L6rbb7YxyGSHaKUORxnB/mw4cGhFLlapVnssHRIgCAlM4+wGmw46dVL9VGKDHDu5uFZCC2jESP4aFSyc9dDa1KZhLiss9pes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770913455; c=relaxed/simple;
	bh=OdDHysFbFD3a/Lf3j9LGjm8B/5TcBkKC682xIC1XPjs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MplTpfB4sGrWXIeoyr5Z7cOcR6kiFpVKBZ3r1pbElMogkRuiMx0Trdwg9LwI1V2GnAhVZksLEOKJoSxTssMqru31n5aIk1yLwnUcFg7a5sEsjFESBSfRA4/jbjiT49szmYq+1nwWUGOgX+MLZ/yd5Pbatq9RUoVVOcax5t5AsRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 2F5F11003D93F5; Thu, 12 Feb 2026 17:15:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 2F15011009FAC6;
	Thu, 12 Feb 2026 17:15:30 +0100 (CET)
Date: Thu, 12 Feb 2026 17:15:30 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: Alan Ross <alan@sleuthco.ai>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] libxtables: refuse to run under file capabilities
In-Reply-To: <aY3aAChfNI3LWvfO@strlen.de>
Message-ID: <qq4or008-331o-628q-rr32-409p846r02o9@vanv.qr>
References: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com> <aY3aAChfNI3LWvfO@strlen.de>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2026-02-12 14:47, Florian Westphal wrote:
>Alan Ross <alan@sleuthco.ai> wrote:
>>
>>Attacker-controlled env vars (XTABLES_LIBDIR, IPTABLES_LIB_DIR,
>>IP6TABLES_LIB_DIR) still reach dlopen(), allowing arbitrary code
>>execution as the capability-elevated user.
>>
>>Extend the existing setuid guard in xtables_init() to also detect
>>file capabilities via getauxval(AT_SECURE).
>
>I'll apply this tomorrow unless anyone else has any objections.

Ah, but we can test for `#ifdef NO_SHARED_LIBS` to see when dlopen
is not used, in which case setuid/fscap-enabled program binaries
might be tolerable.
