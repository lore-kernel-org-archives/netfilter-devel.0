Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF91E7C2E;
	Fri, 13 Jun 2025 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749804195; cv=none; b=W3M+5B2zbmCJ9EJW8fVb0xbR5GbRvA5SCgv0vW+aZ41Ud6tvAaW+LTc7X61SHwYfZ99VlHl9k+HYjMVjr9pc9l6M8ykXzvifLMbz9m/e9IqCNvBirNz6MFzY9Wdey7XQGiDNbvfDTWEI5l3Wd12VR3Q1b1gwJyW7hVA02MMjm2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749804195; c=relaxed/simple;
	bh=TQgcPkkH2EvSX8VHh/RHCX+HKmJkLMLX8iTuebAbBPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=noaShGEgqCohsBsCaNgYhTFUWkxsrFMxauD9YHIVSH7KJd3anWc4cZqqt/DdZU+wi/vvu8o8EDir8Fp5VmcotCU9Iksv+bSoyqGc5c272uzNY7cmmviyFCbowuMnEe/fRvIPCqxqUGXzi0Tpq/JdEJlKK0tvSB0dvh84skrOOnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEyhiyEF; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEyhiyEF"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so9648535ab.1;
        Fri, 13 Jun 2025 01:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749804193; x=1750408993; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TQgcPkkH2EvSX8VHh/RHCX+HKmJkLMLX8iTuebAbBPI=;
        b=CEyhiyEFW2y0D3272xXtUmA5Ob0RhPl7o5URFUPyJWcGZdEvS6kas16oHsigbz8QQA
         L2Ps7uXjoVHCNbvDLl8P9BVMboCcBk5lJLN4wFk0Vkm22mDLglH5C2Gc8nDn6j6fas8L
         oo7TYocQRU6E2sla+ZzKwBUBodXBDPN8z9+PW5r0g10DH7/rdnlC/g2dyd5scp+YBDQw
         /dLOYgMwYavlYe80+pGgbjjHX//iGCuuZiWXgv/OwYtdHET8//6FSOpjlDNrB+JKgvp9
         xkaseb9Zhr29I1wtWw6ZgL4orQ7hIwi4xWQV7ZEwGrevTqrzPeVPzN5n9cl+UP17HMjx
         HK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749804193; x=1750408993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TQgcPkkH2EvSX8VHh/RHCX+HKmJkLMLX8iTuebAbBPI=;
        b=wlnv+FBCgm+LHBOImJHWdnF3qNIFFRj4A6uokWHcWPmq2akuTezoXujaneayIzWMYW
         Fn71apJ7T4Ij85G/85d9UMY0BoSj/O5WIJMr8+3M5eG6NvmLE38PTWd5jcXSuKFuk/QN
         DO2HmucauU414RUfQH81jUI4GN9aP8iUNc+J0xzAxInHoK1g4dKKpNfJhRRE45FpI2Ud
         E09/DG1GZVoFAxaXYQ2+1HMk5X5LwvjY4BkoecX6AUP6hreOkxhbeMKF0fSBw3uZVrLW
         9OpQx+v+DskqK1VTajV792b+4CLRAZuZHyh/7FS+s5jz91eRguH5FfMddd8eBWXVdGGG
         ZiKw==
X-Forwarded-Encrypted: i=1; AJvYcCU6dIhdK4PR7vkh8t2kq+qAQ5JjpdwzY8l4Q2witm7IC20YvKbgWvs7mkOtYtVapdYVed+JbYg=@vger.kernel.org, AJvYcCWgqXyQWtPe82MIOuf0OtehGTljZ9Kuz21g/yNj2OwIMFk5UV5YBeZ2GdG4pd+euJ0qt7i8Sx2AlHov@vger.kernel.org, AJvYcCXXSFHIL/Kcew2jepMKgkVEHnhn9jYliLsq+9pt5VVSsJHoJBTLEHrNAs6HKl0EOLOSOCjy4rbfdeacwXupdNlj@vger.kernel.org
X-Gm-Message-State: AOJu0YwMWB6E9QlR5cVLwSqcBj00aFj6GmUJxCxNLenQcX0B8GlVt9EC
	XMGIgo19s+zbsDHSYdc2wOoCuyjrEZrQZSasAQeggqLSUlY/0hTN/jAe9qMkycNYfYVOgplWl4B
	MNYn7SvKfsdMPa0MqGHwxwZsmCyZ8Oss=
X-Gm-Gg: ASbGnct+8UtrOVRmgk2qgljBcGC8RuJf6ie9/wyF2yMrBcisR5qGAT/IlJZz5eq0wGr
	yTUP1RGwioG+R+p9LYB3bt2byymjZcSo+ejw9kROM4f8LEu1OnfkwLQ9XAaXuSsoJx+b8d4Qhza
	gq41qRr6lxQfkF/Jl36JMAI+e0YqRgKY+gZS3fatt5HQ==
X-Google-Smtp-Source: AGHT+IEfMK1xZf/b+j76ns8CxYTETEivsifS7tniKz+qeKzwhGUNbTP0yo/NztCGXpqTU/SAcwyCGfsiwpsLVUgGy3Y=
X-Received: by 2002:a05:6e02:194d:b0:3dd:c4ed:39c0 with SMTP id
 e9e14a558f8ab-3de00b2d666mr22522525ab.1.1749804193094; Fri, 13 Jun 2025
 01:43:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
 <aEqka3uX7tuFced5@orbyte.nwl.cc> <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
 <aErch2cFAJK_yd6M@orbyte.nwl.cc> <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
 <aEsuPMEkWHnJvLU9@orbyte.nwl.cc> <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc>
 <aEtMuuN9c6RkWQFo@orbyte.nwl.cc> <s4ffjiihvgv6glpvd3rbqr3cedprmgqijxiz2dh6v5lq4doabd@gpis5xfdyea5>
In-Reply-To: <s4ffjiihvgv6glpvd3rbqr3cedprmgqijxiz2dh6v5lq4doabd@gpis5xfdyea5>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Fri, 13 Jun 2025 10:42:37 +0200
X-Gm-Features: AX0GCFuMcnrqL4pjQ0tem2TqFCQdMglEvTyI_uVIKFil4JtU04vwqEeNjlh2Hq4
Message-ID: <CABhP=tYZYC-U1eAp9j8sdnaTUAMQXVSw78XHMkjcyXOdbxRi8Q@mail.gmail.com>
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
To: webmaster@agowa338.de
Cc: Phil Sutter <phil@nwl.cc>, Klaus Frank <vger.kernel.org@frank.fyi>, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, netfilter@vger.kernel.org, 
	=?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Jun 2025 at 00:19, <webmaster@agowa338.de> wrote:
>
> On Thu, Jun 12, 2025 at 11:55:06PM +0200, Phil Sutter wrote:
> > On Thu, Jun 12, 2025 at 08:13:02PM +0000, Klaus Frank wrote:
> > > On Thu, Jun 12, 2025 at 09:45:00PM +0200, Phil Sutter wrote:
> > > > On Thu, Jun 12, 2025 at 08:19:53PM +0200, Antonio Ojea wrote:
> > > > > On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > > > > > > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > > > > > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > > > > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > > > > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> > > > >
> > > > > > > we ended doing some "smart hack" , well, really a combination of them
> > > > > > > to provide a nat64 alternative for kubernetes
> > > > > > > https://github.com/kubernetes-sigs/nat64:
> > > > > > > - a virtual dummy interface to "attract" the nat64 traffic with the
> > > > > > > well known prefix
> > > > > > > - ebpf tc filters to do the family conversion using static nat for
> > > > > > > simplicity on the dummy interface
> > > > > > > - and reusing nftables masquerading to avoid to reimplement conntrack
> > > > > >
> > > > > > Oh, interesting! Would you benefit from a native implementation in
> > > > > > nftables?
> > > > >
> > > > > Indeed we'll benefit a lot, see what we have to do :)
> > > > >
> > > > > > > you can play with it using namespaces (without kubernetes), see
> > > > > > > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > > > > > > for kind of selftest environment
> > > > > >
> > > > > > Refusing to look at the code: You didn't take care of the typical NAT
> > > > > > helper users like FTP or SIP, did you?
> > > > >
> > > > > The current approach does static NAT64 first, switching the IPv6 ips
> > > > > to IPv4 and adapting the IPv4 packet, the "real nat" is done by
> > > > > nftables on the ipv4 family after that, so ... it may work?
> > > >
> > > > That was my approach as well: The incoming IPv6 packet was translated to
> > > > IPv4 with an rfc1918 source address linked to the IPv6 source, then
> > > > MASQUERADE would translate to the external IP.
> > > >
> > > > In reverse direction, iptables would use the right IPv6 destination
> > > > address from given rfc1918 destination address.
> > > >
> > > > The above is a hack which limits the number of IPv6 clients to the size
> > > > of that IPv4 transfer net. Fixing it properly would probably require
> > > > conntrack integration, not sure if going that route is feasible (note
> > > > that I have no clue about conntrack internals).
> > >
> > > Well technically all that needs to be done is NAT66 instead of NAT44
> > > within that hack and that limitation vanishes.
> >
> > I don't comprehend: I have to use an IPv4 transfer net because I need to
> > set a source address in the generated IPv4 header. The destination IPv4
> > address is extracted from the IPv6 destination address. Simple example:
> >

Yeah, my bad, I was thinking about the Service implementation and the
need to track multiple connections for the same DNAT, and this is
about embedded IPs.

> >
> > > Also in regards to the above code it looks like currently only tcp and
> > > udp are supported. All other traffic appears to just dropped at the
> > > moment instead of just passed through. Is there a particular reason for
> > > this?
> >
> > I guess tcp and udp are simply sufficient in k8s.
>
> doesn't k8s also support sctp? Also still no need to just drop
> everything else, would have expected to just pass through it without
> special handling...
>

Ok, k8s support, here by dragons, taking some licenses for keeping the
explanation simple:
k8s orchestrate containers with a flat network as model, as every
container needs to talk to other containers in the cluster without
NAT, there is nothing kubernetes mandates about protocols here, only
about how the network in the cluster should look like, this end to end
principle makes networking "simple" to think about and put the
complexity on the endpoints.

k8s also offers a mechanism for service discovery, the famous
kube-proxy that basically does DNAT to some virtual ip and Port
configured by the user, that is the thing that users can configure to
expose their containers, and this API only allow users to set TCP ,
UDP or SCTP protocols, this is what people traditional mean as
"kubernetes supports SCTP", although the use cases for this are very
niche.

The need for NAT64 in k8s is because unfortunately the world is not
IPv6 ready, so people deploy containers that pull images from
registries that are not reachable via IPv6 or use some git repository
that is IPv4 only, this traffic "from container to Internet" is the
traffic that needs a translation mechanism and is what this project
tries to solve, is a stopgap solution, just that.

The "mixing IP families inside the same cluster", so I have some
containers IPv4 and others IPv6 is something I heard people trying to
do, but that basically breaks the networking model of k8s, since means
some containers will only be able to reach other containers through
NAT, I really do not recommend that, as I do not see the benefit, is
something cool to work with, but not something I will use if I have my
company business on that cluster, you better use multiple clusters
with different network domains and ip families and communicate through
the "external to cluster" mechanisms
