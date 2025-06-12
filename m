Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86CE2C0331;
	Thu, 12 Jun 2025 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749752431; cv=none; b=ow/hDoamloYZRgdqO8FfLCMOneX7Cj2FcEMuBc9x4hy2SvrRkmWRDHHL8uHqQMcLLc6+RTiIVLMaWO/veXFBp1QxBaTSs43RomSqtgFN950ooqeSd49jCF+cBUpattXcGK8Vn5I6gxXuQ0P4ulGgqHxGvZZW+fmlXUK+Snfce8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749752431; c=relaxed/simple;
	bh=NVVgbxJGi4pV+scYO8y++JEJceNMmB7haFmfgb2j43w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=C3pTPaV2PZWhSm4JJO1qxgeV589m5Rnsu1AvD2gnwoHoPVMWwgqHPJLEbn9kB0acd70qsnfxQkLluyYRUmtKYSLjiq4QgoSEF1sPi9nqqAVhafqF8UmoQ0+cuApSkuE6PvXuQT1zSsuyc4vgIlqoj1jMFktbQbCF0wxdl4rdceU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHQy8K8X; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHQy8K8X"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3dddbdef7f0so10956415ab.0;
        Thu, 12 Jun 2025 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749752429; x=1750357229; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NVVgbxJGi4pV+scYO8y++JEJceNMmB7haFmfgb2j43w=;
        b=jHQy8K8XDXX1zFolW5buBOQ/u9JXNWGzCY8GdlyZLO5Imt2hyuGO+FYDTOJeWJ5m5+
         ojfRCFDmnFMorHiQf+UwmMSQau79ylm8fiqjA6WEdWYNRu+7C0ipyniDIEEvv8TSxJHv
         7HcmhlLtc0sYWWBhr4c5NSIqqogxnkV94eaQDaLDTzl1wsH61Ox8q8jU0cWG4RO3aIhC
         RuUjCcLBXOwRb6C3bSVj4o2Q3zrYHbDysVTZi4Kq4TOaT/tiSwQTecH6NTHhhkt8BU1v
         SFSWF8M5PwlYsC/hsOAVttS09oiw37lPhgvQ4P9fywefeRedaVuytNCBoF69qNzY5zm6
         aqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749752429; x=1750357229;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVVgbxJGi4pV+scYO8y++JEJceNMmB7haFmfgb2j43w=;
        b=Oa/fHPEraDRVP7csq9hkkseOv7bBzBVpU0jQLvwf672kQY2p0o5mJxQ7UuSRrZwZhw
         4DEbDsuThJh0CY+e0WKPwag0KQcqXCx2DRVlyARF9jXyzZokTFFTnBKkQvnoxpr8pGLm
         9aUlY8VPyFMTcy3GluBVZNxJ5uyg7Y3yyMwplcOfy4FlTCrwZ8n3ZMJR+3HTn0yv2mYH
         KnNPLkR89d5f3TOqDhVftcpl4NPoU96QmmJpkvrOv4aNlXTA1PuzufmDGNG7JdDQbY+2
         8FG1WoKmAdPQz0KaMLSPlXqcrxIc0tRuUoyzja7EgDU9pHai+sWIUm6pZefzSRrQcyG2
         dAoA==
X-Forwarded-Encrypted: i=1; AJvYcCU2CFP/h4sXKdU/nQkSee2yeqXABW+y/8YABiu3Jzi+VBeifg7L8hBNk6FMyAwYhKj7iSkZnRZlCM2p@vger.kernel.org, AJvYcCXIQ02crzTtqW3ImJFIShbsRLWXmlG6wb97Sn81UDvEVqxoeAnZ+foa2yn7wjG5auYp+4cVsgg=@vger.kernel.org, AJvYcCXeErqDBTNt54WJUeSUoJLiVmuUKZ6UvEkqzHCPsE76uHET2ImO66RhsIVHyW6t8r+aKz4E6f0ukM0eCFFaQBYN@vger.kernel.org
X-Gm-Message-State: AOJu0YxR/WGerfz51JWYltF80YwLDeZAeCoG6CIYi4DZ9KAkN/zlwWc8
	HGIDoRZdBKKkS5F0v6/U9sc5eMuTH8Om8gfwvHcA77p3avp6Eh5a7EF7p5UtzXThKaUn2m6ZQgF
	VRpE/HJMR760RoSjL2OpPllsWrqNJacQ=
X-Gm-Gg: ASbGncsn+CUROzJqmV+G8noSrQQ/u0EH88n4HmZZUwBrsa+wX8uC/lK0HaAP6wz85XQ
	oEk+10PuCIKly9GuRgb+tFKFlgiaT6v8EbhVGkneUGPV0B34O1rTIYibMY8yi9STKAJTuRUwMHk
	oEnr2M/yvtgRiiEG53jnIM0YnTUUBGbTqFlkTiQnr9
X-Google-Smtp-Source: AGHT+IHb0wSEDeQHWHI2dMD634OfwFTGxe3ouDxHtVIZxIZbe7QBpbAbtVt0u3NdziLXU5NsgrmbUd/F3N1CZ33FqfA=
X-Received: by 2002:a05:6e02:1a43:b0:3dc:8b2c:4bc7 with SMTP id
 e9e14a558f8ab-3ddfa80be92mr59554815ab.1.1749752428993; Thu, 12 Jun 2025
 11:20:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
 <aEqka3uX7tuFced5@orbyte.nwl.cc> <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
 <aErch2cFAJK_yd6M@orbyte.nwl.cc>
In-Reply-To: <aErch2cFAJK_yd6M@orbyte.nwl.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Thu, 12 Jun 2025 20:19:53 +0200
X-Gm-Features: AX0GCFsYScf9H5vRg9wxsbe7jT3iDs2dBG-naVHm6oe0uV8s4W_cR65_YbTHDnI
Message-ID: <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
To: Phil Sutter <phil@nwl.cc>, Antonio Ojea <antonio.ojea.garcia@gmail.com>, 
	Klaus Frank <vger.kernel.org@frank.fyi>, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, 
	netfilter@vger.kernel.org, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?

> > we ended doing some "smart hack" , well, really a combination of them
> > to provide a nat64 alternative for kubernetes
> > https://github.com/kubernetes-sigs/nat64:
> > - a virtual dummy interface to "attract" the nat64 traffic with the
> > well known prefix
> > - ebpf tc filters to do the family conversion using static nat for
> > simplicity on the dummy interface
> > - and reusing nftables masquerading to avoid to reimplement conntrack
>
> Oh, interesting! Would you benefit from a native implementation in
> nftables?

Indeed we'll benefit a lot, see what we have to do :)

> > you can play with it using namespaces (without kubernetes), see
> > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > for kind of selftest environment
>
> Refusing to look at the code: You didn't take care of the typical NAT
> helper users like FTP or SIP, did you?

The current approach does static NAT64 first, switching the IPv6 ips
to IPv4 and adapting the IPv4 packet, the "real nat" is done by
nftables on the ipv4 family after that, so ... it may work?
