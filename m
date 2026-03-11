Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14D8359A8F
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 08:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773217647; cv=none; b=gz/0K+ssCFG8uJjg4UBm7k/71RkdrD19FSlVj6t83fMhicEGOwgdP2HOd+9Eb6jYVMOuvZxgJ/0YK1R1eEOPKqDotaphZx+nJDBNGigEkIHa1g+iIToRTstB/Zr1mWcfeB6z/qHWrY8LZQErYlwyjhghi/uQQaVsUcmzVjBFAhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773217647; c=relaxed/simple;
	bh=62QCpDXQ19DuCkEVmsTIfiPIA4bbzZLKZDd0zU0n8k8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pi5Dba3DZvGDBgT5n2tXF9Ie487SvyqmyyHiFMrlYrrSB5bDRgae8j2xjgCNXYCOdrGfrIy7sOpetv0+ixsAbcUBzKAN64N8UBUAfq9kF0udpqMbCf/4rsBLgGWqOTz6ruk38bws76JMjAD3YvHtuIEynOuutLXNzSkm6oPJKwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899e87b04d8so180005726d6.3
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 01:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773217646; x=1773822446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OPUxC4UVYYzFR5WbkDP1rfKgT9C5RxhWe2cP85gtoTg=;
        b=H6X6Q0ZabAp2dldj1XRRSjV0cimzmxkjvFA/8cD/gdep50vhMwPlaaLN3EDg8I7h0m
         jSAAAnJ5XskmWqcH1T7B8lmGKaIadfFKpJSUXsftzcjqGedrnh4eRecCwSBTUAYeEK+V
         WJu2t74vUDdEYjvh2jRQ243W3j+PDKIUwvylgRMdgtbuVJLExGwgo+tPLBlRJacDV8J1
         EBoyLL4jlLDe28T21l0cbrJ51wcp1fR8K2uqhR5vFRy8MpRTn/dgzEZrrTQf17cGGLYz
         p1Cam7IBaIwZhYkFW9msUQtWzlriQCac/uaNCnypIiMTCP+c8VwJp2eaoPKNdVmPzZtO
         tsAg==
X-Forwarded-Encrypted: i=1; AJvYcCVEiglBX+5FuqHWmqQyZeRv2GyfqxEIVWGFBIyaxi/+RQsQPmis4ZivyU5ekBo4mgZkJNRYw1EWcVhlXBKekHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YymFcgJ2Ee2IoBgoBrXCp3iszirtYwpxMKSYQc7rdclNfKU/IxM
	2kLBTJZ5HMskgO+WCZTnr0KgDfPqcjvWECteStzt6s7VxeJ9HHvev0j7oiLhrVVH
X-Gm-Gg: ATEYQzzyzly6fVcwceCqRDwhFw6CHLrDSdxfJ/t+QDrYafoMOmsVN72i5aNWRUBe2My
	eq9z8eVx3chhRgwuUDkBBkVE1kSFXK+F39e5JGHlK3LfCS56g2XLHyu1ARCdTRA+pBzpWdppVNN
	LcK9/+FR25C6Pm6K5F1TcQbBBR7X/dpkGw5lLf8nurCmBbX1CylDBx+iVsj4P+Hxg0y1F/VQV23
	KLKgcVJnf6bREmmg7qpAVs5h+cRv+AYhVnlQCywI+1GIoMAXTALUhAZraw8f5WSIel7XSrxj6Nj
	KluVYPZEw1FP5XmQpJROpmo6XwGUAr1l2eBJvyPljgpxFYD1Vq2lgdmgmq8OKrIP5sV428c9vZ6
	RoEqxU317fQpTeP+I7vSx58dAjMPn0Kfm1ESr68zadSX9JZR8uT/KXxfz+UUMKKVtmeuaks29UY
	mGVGj+or1m3OnXlgb1u0+4wuRfaitn/U7tewYsenSWsv3Gnx2BLY3OOukKIFIu2h61
X-Received: by 2002:a05:6214:1bcc:b0:89a:1069:d224 with SMTP id 6a1803df08f44-89a66a495b4mr20967376d6.18.1773217645614;
        Wed, 11 Mar 2026 01:27:25 -0700 (PDT)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com. [209.85.222.172])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a69bef2cdsm4853956d6.25.2026.03.11.01.27.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 01:27:25 -0700 (PDT)
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd858e860aso429744485a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 01:27:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUCxp2LyEoxodNu/yKh2J04JTv6o0yPpr8+PulzWNE31mpjxw9c+meRrb3G243l+O8540RHT/zF1GTGh9GB18=@vger.kernel.org
X-Received: by 2002:a05:6102:290c:b0:5ff:d192:ff22 with SMTP id
 ada2fe7eead31-601deec1db1mr739173137.19.1773217280031; Wed, 11 Mar 2026
 01:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309022013.5199-1-fmancera@suse.de> <20260309022013.5199-2-fmancera@suse.de>
 <01a4936f-77cd-4c60-a1be-cabec872a2bb@kernel.org> <e54d887c-5a70-b8c9-aeef-433c5134dd14@kolla.no>
 <5c4b6043-a484-479d-83bc-a86ecdb8f810@app.fastmail.com>
In-Reply-To: <5c4b6043-a484-479d-83bc-a86ecdb8f810@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 09:21:08 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWec3Xwi1ma22D_eqs3OqRJXEt4=YmWvO2MgtBdSpNuqg@mail.gmail.com>
X-Gm-Features: AaiRm52Q0QeELW2kE8F3ZB9XQa9qhSRDKWOoNuroUdAnxhN87qOfxCDKsawyRAY
Message-ID: <CAMuHMdWec3Xwi1ma22D_eqs3OqRJXEt4=YmWvO2MgtBdSpNuqg@mail.gmail.com>
Subject: Re: [PATCH 01/10 net-next] ipv6: convert CONFIG_IPV6 to built-in only
 and clean up Kconfigs
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Fernando Fernandez Mancera <fmancera@suse.de>, Netdev <netdev@vger.kernel.org>, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Selvin Xavier <selvin.xavier@broadcom.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	"maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" <GR-QLogic-Storage-Upstream@marvell.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Varun Prakash <varun@chelsio.com>, 
	Alexander Aring <aahringo@redhat.com>, David Teigland <teigland@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	David Ahern <dsahern@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Jon Maloy <jmaloy@redhat.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Michal Simek <michal.simek@amd.com>, Luca Weiss <luca.weiss@fairphone.com>, 
	Sven Peter <sven@kernel.org>, 
	"Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Gow <david@davidgow.net>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ryota Sakamoto <sakamo.ryota@gmail.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kir Chou <note351@hotmail.com>, 
	Kuan-Wei Chiu <visitorckw@gmail.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>, 
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>, =?UTF-8?Q?Markus_Bl=C3=B6chl?= <markus@blochl.de>, 
	"open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>, 
	"open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, 
	"open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@corigine.com>, 
	"open list:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" <linux-scsi@vger.kernel.org>, 
	"open list:DISTRIBUTED LOCK MANAGER (DLM)" <gfs2@lists.linux.dev>, "open list:ETHERNET BRIDGE" <bridge@lists.linux.dev>, 
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>, 
	"open list:NETFILTER" <coreteam@netfilter.org>, 
	"open list:RXRPC SOCKETS (AF_RXRPC)" <linux-afs@lists.infradead.org>, 
	"open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, 
	"open list:TIPC NETWORK LAYER" <tipc-discussion@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Mar 2026 at 20:58, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Mar 10, 2026, at 20:40, Kolbj=C3=B8rn Barmen wrote:
> > On Mon, 9 Mar 2026, Krzysztof Kozlowski wrote:
> >> On 09/03/2026 03:19, Fernando Fernandez Mancera wrote:
> >>
> >> It must stay module for me. Alternatively, drop it, but then some user=
s
> >> will be really affected.
> >
> > I agree. If anything I would prefer to see IPv4 be made optional (and
> > modular) as well, and not as something IPv6 depends on, it's (AFAIK)
> > impossible today to build an IPv6-only Linux kernel.
>
> My first feeling was that this is a bad idea as well. On the other hand

Exactly my feeling. That's why I stayed quiet for a while, and gave
it some thought...

> I found that the default changed from =3Dm to -y over 10 years ago, all
> recent distros listed in https://github.com/nyrahul/linux-kernel-configs
> use that default (the only two exceptions are board specific builds
> of Debian and Ubuntu for linux-5.x).

Thanks, that is something I was wondering too.

Obviously the world is moving the IPv6 (but having IPv6=3Dm doesn't
preclude that!).  From the other side, there is a trend to have as much
as possible in modules instead of built-in.  A larger base kernel not
only has impact on memory usage (and loading modules has, too), but
also on e.g. boot partitions.  Various platform-specific limitations
may be at play (boot loader size limits, boot partition size limits,
base kernel must fit in the first memory block on systems with many
small discontiguous memory blocks, ...).

But apparently even the Android gki_defconfig (which is not on the
page mentioned above?) has IPv6 built-in.

Back to the numbers:
  - base kernel: atari_defconfig (CONFIG_IPv6=3Dm)
  - with this series, CONFIG_IPv6=3Dn: -22 KiB
  - with this series, CONFIG_IPv6=3Dy: +246 KiB
Note that I ignored any defconfig changes in these series.
The size impact is almost the same for v1 and v2, but only v2 boots.

Each new kernel release increases kernel size by ca. 30-40 KiB on
average.  So a one-time increase of 246 KiB is not unsurmountable,
and slightly less than the increase between v6.14 and v6.19...

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
