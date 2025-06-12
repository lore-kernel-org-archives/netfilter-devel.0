Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA11F1313;
	Thu, 12 Jun 2025 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735287; cv=none; b=V5P6fK48MflfxbdwUdZfpzVIgfe5TuclYe58pAOznnORqgwy+n/fikjO6tM8ATPOtCty0NZwhosVxYcgooWb3pX1NEIYLjyzNCmX1H3pEG1K+ljfl0bJtLDHtgFgltcmXWzbn9iuA65ag22O3Eqc8ZoSBvUiZu2DmdXlaBU14mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735287; c=relaxed/simple;
	bh=j0Jh4tYrTYIYXkFr3dAsdn3bipBKHmzXFsKxvBxyMKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=MuK7BKGE47xX0qqYvy5+5UifbX1JYDG0X0ZUzuydQfBjy0NiQwe7prXsyeK3qri7txcZ1TpxeIl0CT30wPMc4+rggnyiOT9UaYnkqzq8Kfpm069XQmKM4a9ow3/yhU9mFQ7wmIJEGpMPvJtJFv/OORdPqx1SJ2VJT+BNbi5l79g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLmt3uPU; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLmt3uPU"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ddcf0edef6so3834585ab.0;
        Thu, 12 Jun 2025 06:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749735285; x=1750340085; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j0Jh4tYrTYIYXkFr3dAsdn3bipBKHmzXFsKxvBxyMKs=;
        b=cLmt3uPUBs9b7uFEZOsqNFUVEKX+XrAiyOu3yjh6HG4DAtols0Le20xaXuPp4i9t29
         CE1WpJRZwR0XN2E65bNVzmifc4oaXzVGE1CRtvXtmqvU5vardWzlu3kJ4osgbxLBHite
         xSgjxjBBaEGnLJpoYY4DPraDDF4JAuoyvalQusZ7IRmsDux25yViQkB5/M7D+klfhTEx
         Nn5N1NXDkvNQKio/L0QC1AJ4I6/egsyeqMy6rDkWBQe0QFOGrSZnvQ0nmd5EEGb4FCQ1
         1TaukpEqGj2oatpUc+/v7UgAqEYmVPs5FbSkylm+EtgMltxKXG/nTYkGYfiM/BmtOH5G
         Ey8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749735285; x=1750340085;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0Jh4tYrTYIYXkFr3dAsdn3bipBKHmzXFsKxvBxyMKs=;
        b=s+Q+EApLUX4Zx6c/KqpUQ6ignRjjRK0tf6CI8uTs9qp2N6Oc2IhxdNnkpfpbj1FV0k
         rzD7QrYQFNN6H7Fm/gJYXVPhbVSpdTufTRVVOA/7+lpGp/xuMMDHOaNIS8GsjHJ9HfxX
         vRt3Y+aavWiRs+YVVl1EzT/mh/srKd1Ndeg16Mbrb2xOmF8sRwxKDxnY/XTp6/G3FbzL
         YLXB0v2sD1eUoV7n2SzTTw+PhlJU/D20qP/sFu5x7AIDeuA8PFLAI/o/l0k3+f6FQWBB
         lmD7Mi8drONW4P03xH9/42ZfLwJkiCyhQTRymB7MXWW6rT/29CF0Xy+OIcucTp52PEpR
         2Q3w==
X-Forwarded-Encrypted: i=1; AJvYcCU++7QwcJrldYv4pI0Y4qmje/cLo4VgCO1z5s6tqACVHjIjHoiHpSOnka75Ytp7p6ZWQyfObwleJRN5@vger.kernel.org, AJvYcCVk3ayVtXp0HiX7lVVPh1mDoTmmLtefRtYBgP/klXSgzVjYVWcvjc8q8L66bkvSr1tePgVEHgA=@vger.kernel.org, AJvYcCVzbKJN7iBRTDGKHh/aQ27OSLRcBdsrOU0RgUZMxdCPMA71C1HedgGqJDY6R+tJNcInjA6Z2uNRvNcNl7n1IJ2s@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Tve8IPYrMrXX4un0QmBAjqRC6tqdpE1w7ArM6SGN88KXHrAl
	ZeCluX41x9L2Gw657SfWzBNwzlh4kH6ReDfuX0zgtc33czBesmMAi+llUF2TNOr2f2Se7Uww8M9
	h3TYOOCYRr8g4nGm9Pu5i69Ddri++fp0=
X-Gm-Gg: ASbGncu21H89AehqgSQBT7Uie6jq6IYwe/d4Od+yS4mCOaZXOQ1iX9HCFV42DCJJqcM
	6Hzes+n1+nl5BtJ9935eZfxSkdtPjpLoY6lFXsY1XtOoaGguYyDQYaJrCSIHb/8J7Ze9Du60z39
	CZ/HBj2n6lHGciGsuPDm0K5gleNRqGLDfK1fDl1XrEuLS8tcXXCsU=
X-Google-Smtp-Source: AGHT+IG3xjEqPKsGvqvhSvCDbuxWOcwvX+S4KLU09uPWFj/eXBmn5EowZoRSZETGG4EYp87iIsCJrp9dNoRTEAEI9pk=
X-Received: by 2002:a05:6e02:339c:b0:3dd:bba3:5348 with SMTP id
 e9e14a558f8ab-3ddfa874d0fmr41737125ab.13.1749735284985; Thu, 12 Jun 2025
 06:34:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b> <aEqka3uX7tuFced5@orbyte.nwl.cc>
In-Reply-To: <aEqka3uX7tuFced5@orbyte.nwl.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Thu, 12 Jun 2025 15:34:08 +0200
X-Gm-Features: AX0GCFuqtgDl0YkvNLDm1K0GuiB9OzYvWJVL4r5Dukxv45-V2hxmltj3IlmNZgY
Message-ID: <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
To: Phil Sutter <phil@nwl.cc>, Klaus Frank <vger.kernel.org@frank.fyi>, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, netfilter@vger.kernel.org, 
	=?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > I've been looking through the mailling list archives and couldn't find a clear anser.
> > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> >
> > All I was able to find so far:
> > * scanner patches related to "IPv4-Mapped IPv6" and "IPv4-compat IPv6"
> > * multiple people asking about this without replies
> > * "this is useful with DNS64/NAT64 networks for example" from 2023 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b308feb4fd2d1c06919445c65c8fbf8e9fd1781
> > * "in the future: in-kernel NAT64/NAT46 (Pablo)" from 2021 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=42df6e1d221dddc0f2acf2be37e68d553ad65f96
> > * "This hook is also useful for NAT46/NAT64, tunneling and filtering of
> > locally generated af_packet traffic such as dhclient." from 2020 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8537f78647c072bdb1a5dbe32e1c7e5b13ff1258
> >
> > It kinda looks like native NAT64/NAT46 was planned at some point in time but it just become quite silent afterwards.
> >
> > Was there some technical limitation/blocker or some consensus to not move forward with it?
>
> Not to my knowledge. I had an implementation once in iptables, but it
> never made it past the PoC stage. Nowadays this would need to be
> implemented in nf_tables at least.
>
> I'm not sure about some of the arguments you linked to above, my
> implementation happily lived in forward hook for instance. It serves
> well though in discovering the limitations of l3/l4 encapsulation, so
> might turn into a can of worms. Implementing the icmp/icmpv6 translation
> was fun, though!
>
> > I'm kinda looking forward to such a feature and therefore would really like to know more about the current state of things.
>
> AFAIK, this is currently not even planned to be implemented.
>
> Cheers, Phil
>

we ended doing some "smart hack" , well, really a combination of them
to provide a nat64 alternative for kubernetes
https://github.com/kubernetes-sigs/nat64:
- a virtual dummy interface to "attract" the nat64 traffic with the
well known prefix
- ebpf tc filters to do the family conversion using static nat for
simplicity on the dummy interface
- and reusing nftables masquerading to avoid to reimplement conntrack

you can play with it using namespaces (without kubernetes), see
https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
for kind of selftest environment

phil point about icmp is really accurate :)
