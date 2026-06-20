Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D42A35C190
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2026 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781988287; cv=none; b=WTAX9b0T4Bihcp+WG7IXhAjsya/tS0wUbX5gIr8JM/0424Jx/FS5v9vXEViMkWdCGLWutuhMfqrzIyznXXnZZLDwcxGIiGr8EMqX9Lk44ld9p3FMNDlHANC1g2c3VenZBk7vUbRzMjBznRQ11ehy4jXuYEt7+0RGDlOLpjmhUhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781988287; c=relaxed/simple;
	bh=U7AqPRs5Is8Is9SjOZmekPXBSghQ5JGw1UeCdOvvZvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYg7UXVN6BtyyiugIjimyeIzoUlxg02V4Pcu+tQVvnQW8VhJ/d433nRabJBaU1+7autPYyoWLFsvP/IVLZDggq31+gCir/AIRRp/N2jk/bEUB2BBotqr8cd8IvHTVH8oVT3qaNmieJVbkNrjvZ2WPrTLKWJ4hyu73jHh9PtUuaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUPBIixa; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUPBIixa"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4624c1409c9so2323896f8f.3
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2026 13:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781988285; x=1782593085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KEJeIuAOhsEHJ09iO7qVlqN+PvloGiCYoriT6c3hYsU=;
        b=LUPBIixazRPSirqDkp63niS5WeCN1ro9nfbI/OSPEVtweqvBR0fp37KJ68AGl0psaL
         NWBF1s2L8Jbk19PyvrNWeI5AXRYbbgeOJC9Wy8Kn0kn4lio+V7dgYcAywe5gX32PhCcO
         OiuOiHQiKoDL+q0F26VF6jyS+aFINcy2s1td5I5NxLLtykxYIYJN0AslHz/GivWGCKql
         H4t+geJKHgfdesazhdUaMp6jjl0gWi2Cj/xOzYD7+imKSPME5uintZ/HoNHpF7RIaR7i
         aAAVmp65b3IKSQPDyjN24v9vFyJt7m8wOUn/Q7rqIUsdhbh8I4EdeH6QeGiOCZPbAhNf
         GAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781988285; x=1782593085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KEJeIuAOhsEHJ09iO7qVlqN+PvloGiCYoriT6c3hYsU=;
        b=rfV0cGZGY9Oth3/OYJziHtbEnSxh23JWREqGNNkM531Ega3qGR+jDwT5v9cKSZL4R4
         8928Fa9RG7zSbpxeIefUdrb69dyjgBjSAMD6WAUo1jvkfg5vXL1VGlekly+liPeVctDn
         h8i8Gpi1YL7+mjuniU7S8bbOWebQ5Xn8qYTJUReu8bW0zPhDdRzymWrEJadQMsVu8Kmb
         dEJTJprLW7jeYSudT458Dyl1OA9R7Ku7ge/V4mgAKu7rjyD9Sc4JwMBxHpCpDL32mnox
         RKcnLSop2vF8ijvaUlZ55dY2ueRihUhXbZ8XQRtgKPiOCOlKG6O/6kaP/rDPPA4ih2Cc
         oA/Q==
X-Forwarded-Encrypted: i=1; AHgh+RomJJp/dt3FXD7ZRXbRlhCmnmEmlOHTvf/6gb5qMKvVOq3Ic04QjWOWbwgVwKtS2voE3IjrMZNISD9UzLouET0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywij7nyqvDFVXGHBT13oiXhxf7nbo43JVCmBrZGj4eT2n0j6HGl
	58QPSctiWIaPO3+j3ZWLWNfTQYWynFJ61uumxCVMjdxeI8w7nIzxhT73
X-Gm-Gg: AfdE7cmK2juWyfzpeWZSYgdSQHrMbEZtjXyxqDwM9/Q3+qtWnAggHr29uBzIQmor8eF
	A7KKtEdgMFkRiAmoVLj4JWUDF6ey0XWSscBG1VGwqIlTUUALSkSeKHfoNsNq/8g3ta4BkPKmHf+
	TqzOi59Vgkjrk3LLKCIlX0ljYRRAyBxUV3XUyfdq/zsJk6hQzp0qb4ZVo3gGu39weYxumOF1kdh
	FbA1OvEJaQzDOfOhkPKZWCvE1WjsnK5W4qXG73RWJ7Xjju5ufyokU0b4Z5QZx+FrG8Ts7lGfgKw
	Zjlz87r8wRiGSxAcvUVdu6pxRjJBMp5V8SYTfghzkCNpmH0dd8qRG1xVXfDqx2HVVv048Ka+M/F
	Qlr6GM44PFqk1bJ8AZc0XqdgbtN1dS+TACUD2o7+jO0mUGWpYyuK3wxhjUA9QUxR8aPLcg/zAEN
	yieow+VxfJYMMFaHoA46B//Pfv7xm+SDHNwxk3yVMx/NGlraTX
X-Received: by 2002:a05:6000:46d9:b0:45e:ed7f:1dd with SMTP id ffacd0b85a97d-46662334b91mr4727341f8f.25.1781988284592;
        Sat, 20 Jun 2026 13:44:44 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm12184790f8f.7.2026.06.20.13.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 13:44:43 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 41C3BBE2EE7; Sat, 20 Jun 2026 22:44:42 +0200 (CEST)
Date: Sat, 20 Jun 2026 22:44:42 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	Alejandro =?iso-8859-1?Q?Oliv=E1n?= Alvarez <alejandro.olivan.alvarez@gmail.com>,
	1130336@bugs.debian.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: Bug#1130336: [regression] Network failure beyond first
 connection after 69894e5b4c5e ("netfilter: nft_connlimit: update the count
 if add was skipped")
Message-ID: <ajb7ugG5mYxYIPva@eldamar.lan>
References: <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de>
 <abW2MAAqLnKZm3KF@strlen.de>
 <177322336258.4376.10097494324750307114.reportbug@Desk1.simalex.iccbroadcast.com>
 <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de>
 <abqfSB0TUik1kRU4@eldamar.lan>
 <e24a281622cedf9e8f4dc93c961813aeb7b6ce4c.camel@gmail.com>
 <8788e351-553f-48da-a6e6-ce082adacb8d@suse.de>
 <0b8607c8-2d29-4fca-961a-b7a677e968a1@leemhuis.info>
 <f67a985f-c6a0-4796-b255-59d99e317b6f@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f67a985f-c6a0-4796-b255-59d99e317b6f@suse.de>

Hi Fernando,

On Wed, Apr 22, 2026 at 12:32:34PM +0200, Fernando Fernandez Mancera wrote:
> On 4/22/26 11:18 AM, Thorsten Leemhuis wrote:
> > Lo! Top-posting on purpose to make this easy to process.
> > 
> > What happened to this regression? It looks a bit like things stalled and
> > fell through the cracks. Or Fernando, did you post a patch like you
> > mentioned? I looked for one referring the commit or the reporter, but
> > could not find anything -- but maybe I missed it.
> > 
> 
> Yes, it stalled and fell through the cracks. Let me prepare a fix as I
> mentioned.

Did that happened? On a quick chek at least 7.0.13 upstream seem still
to exhibit the problem (or would it be fair to let this usecase rest?)

Regards,
Salvatore
