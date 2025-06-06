Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4419F12A
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2025 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749228478; cv=none; b=nXN8vx0hTzaZCMtPbY4TI6YgIxpjYzhgaKcYvSxe08qW4NiJ0bpwq3MAL3PTKJ0wydKIFwUljTK5gF+pYPUn4dWMWph/fxzewhxewKeuCJvXhaJ1/m4nkcZBi/7JO8iqo2rG0i+Q0IUoA9qMR8h9yvpdg0riHfw+XC6U1/DZBKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749228478; c=relaxed/simple;
	bh=lRde13dmV7CSyOLdFnU9W4XK/A21JRS8H3LG+dSUW30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQWiMbl/22cb+7RlHtqTOn7Cs0Grwo9QdoXQR7o7AnV+zuWQH5Qkz3GihAtuirGZSboeDalYLrKHd2taQ9eVtTbMZNspgEJo/7BONy6o8tkmrQfg10EWZMyxD3lsadQPrz5MOduuJB9bJxLWuDr//VfFLSE9AKSCoTk9PVDCxZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UUk7Q9On; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UUk7Q9On"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749228474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUwQf8WlIZ8D0BQFWmZ50jT0lmugMKDLIEF8foW4/9k=;
	b=UUk7Q9OnPcErOgzB7zafYgNAq0YYPj2MbQ0tbikrt4lSoEqUhzjkFbGlM0q1KzRRkj/QN8
	ejiWTjYFFqGcHoDvK7qw6Dlki7BdTWj+fgJsElwPnzMKHBvkkKg/b3BOX2p6+7H1O/W6xW
	7ayISc+UJaAxOU4mDLRtcdH1NIIbuKo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-OqfwvIEiP6CV9xo737KGTw-1; Fri, 06 Jun 2025 12:47:53 -0400
X-MC-Unique: OqfwvIEiP6CV9xo737KGTw-1
X-Mimecast-MFC-AGG-ID: OqfwvIEiP6CV9xo737KGTw_1749228472
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-311cc665661so2045466a91.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jun 2025 09:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749228471; x=1749833271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUwQf8WlIZ8D0BQFWmZ50jT0lmugMKDLIEF8foW4/9k=;
        b=HJCmA6p8cro88LyM6cwTYPL+/NCsjlBfLcI7oB1Nu64FF7XqqssoZ8oqhPv9y69uyH
         t6MuEnCz/BX9+ZHEaALqY8sG7xW/oiejj7B1XOc5vqP1d8QfRIRAwciCYMyJ6A9IFpS3
         NrcVplZFht17zLRdfO7LH1E8FsLzn78VCYao3AztnDlOH8S1mb5ZGSxNz2WYG9EiyD5U
         AbW6taLFIrifw1o1ofrgciPkU2gUOv/zf5fp1Tm0kpP1VlDnjECuSFeGrbJ2kDizHq3/
         /c55AT058JGRmArB1EMcWcekmPqqgyQQkVkdiNc2eHrHBR1kjlgVlf0SuKTu18Bh1lnl
         MHTg==
X-Gm-Message-State: AOJu0YyWvJsyz+Nd6sU2RR3T30Jeo5OfoXLmxANvehhwi/C2qyO61kZs
	rbnSHVdf45hsW3aka7uZ8BiLoLzHWywy6tgSizoNrdnA4zTLD03E+otNG0j1zE1kRk/oFCeqWce
	pDUir6wtKdkmWc/Xu5NtlsIlqc+gEI2GNpZr+0gTPZHnjMIZczEhugz5Fdgwyl17QJk0HlD90Cl
	2X3oO7km06DdtrFiY4wED0KrLQ6FHPnEF9pHUYMQIBm8f0eB50CaK97ml2zg==
X-Gm-Gg: ASbGncs27/fDJK1ZMvKAlNJDi9OnS1IqxrWQABSYf/2bM0wlqjO4o92anNlU1VaUfXd
	Nwjhutp2tmwB1nkNm7Tdar/61+dh3RKiQwnSO/IjUi/YMRk3obQn2wSC3FaKMXfSRgSM3baiMsl
	Amecy7
X-Received: by 2002:a17:90b:274a:b0:312:1b53:5e98 with SMTP id 98e67ed59e1d1-31347695f46mr4713953a91.34.1749228471524;
        Fri, 06 Jun 2025 09:47:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6mFgOfqmgbfn+Z4d7ihte0dpNCN0++fJRhzCHELtvwfUFK9QXoTmdtiQggKXIzjb4Qu2CTaMjwjHydSfiZyA=
X-Received: by 2002:a17:90b:274a:b0:312:1b53:5e98 with SMTP id
 98e67ed59e1d1-31347695f46mr4713942a91.34.1749228471151; Fri, 06 Jun 2025
 09:47:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605103339.719169-1-yiche@redhat.com> <20250605104911.727026-1-yiche@redhat.com>
 <aELx30qiSdDJ40vl@strlen.de>
In-Reply-To: <aELx30qiSdDJ40vl@strlen.de>
From: Yi Chen <yiche@redhat.com>
Date: Sat, 7 Jun 2025 00:47:23 +0800
X-Gm-Features: AX0GCFuXynnBqn8g4v_E_qOsyXnCinoyeiTPZV01xi8nnOHV_JjzK6EHcHk5b6Q
Message-ID: <CAJsUoE38FbpdGGGMkjLOyc5z5bQt9hviex2UmD_zcHuWNhY1ew@mail.gmail.com>
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> +tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q F=
TP
Why tcpdump check is needed:
If the snat rule doesn't work, does this test still pass?  "cmp file"
pass doesn't mean the snat really happened.
Add tcpdump check to make sure NAT really happened.


> tcpdump_pid=3D$!
> sleep 2
> ...
> kill "$tcpdump_pid"
Sure, will do.

> So no files are created outside of /tmp.
Sure, got this principal

> +INFILE=3D$(mktemp -p /var/ftp/pub/)
> This directory might not be writeable.
Sure, vsftpd must support a custom file path. I will find the configuration=
.

> Is tcpdump a requirement? AFAICS the dumps are only used
> as a debug aid when something goes wrong?
tcpdump is widely used in our LNST test cases. for example check if
one packet got modified.
Is it bad to use in upstream tests? If you still feel strange, I can
remove the tcpdump check.

What I care about most is whether the ruleset in the test is
configured correctly.
One only needs to NAT the control connection =E2=80=94 the data connection
will be NATed automatically.

Of course, if there's a better ruleset that can exercise more kernel
code, that would be even better.
Will send out the next version.


On Fri, Jun 6, 2025 at 9:49=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Yi Chen <yiche@redhat.com> wrote:
> > This test verifies functionality of the FTP helper,
> > for both passive, active FTP modes,
> > and the functionality of the nf_nat_ftp module.
>
> Thanks for this test case.
>
> Some minor comments below.
>
> > diff --git a/tests/shell/features/tcpdump.sh b/tests/shell/features/tcp=
dump.sh
> > new file mode 100755
> > index 00000000..70df9f68
> > --- /dev/null
> > +++ b/tests/shell/features/tcpdump.sh
> > @@ -0,0 +1,4 @@
> > +#!/bin/sh
> > +
> > +# check whether tcpdump is installed
> > +tcpdump -h >/dev/null 2>&1
>
> Is tcpdump a requirement? AFAICS the dumps are only used
> as a debug aid when something goes wrong?
>
> > +INFILE=3D$(mktemp -p /var/ftp/pub/)
>
> This directory might not be writeable.
>
> Can you use a /tmp/ directory?
>
> I suggest to do:
>
> WORKDIR=3D$(mktemp -d)
> mkdir "$WORKDIR/pub"
>
> ... and then place all files there.
>
> > +dd if=3D/dev/urandom of=3D"$INFILE" bs=3D4096 count=3D1 2>/dev/null
> > +chmod 755 $INFILE
> > +assert_pass "Prepare the file for FTP transmission"
>
> Including this one
>
> ... and this config:
>
> > +cat > ./vsftpd.conf <<-EOF
> > +anonymous_enable=3DYES
> > +local_enable=3DYES
> > +connect_from_port_20=3DYES
> > +listen=3DNO
> > +listen_ipv6=3DYES
> > +pam_service_name=3Dvsftpd
> > +background=3DYES
> > +EOF
> > +ip netns exec $S vsftpd ./vsftpd.conf
> > +sleep 1
> > +ip netns exec $S ss -6ltnp | grep -q '*:21'
> > +assert_pass "start vsftpd server"
>
> So no files are created outside of /tmp.
>
> > +# test passive mode
> > +reload_ruleset
> > +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap =
2> /dev/null & sleep 2
> > +ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121${IN=
FILE#/var/ftp} -o $OUTFILE
> > +assert_pass "curl ftp passive mode "
> > +
> > +pkill tcpdump
>
> Can you do this instead?:
> > +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap =
2> /dev/null &
>
> tcpdump_pid=3D$!
> sleep 2
> ...
> kill "$tcpdump_pid"
>
> ?
>
> pkill will zap all tcpdump instances.
> Since tests are executed in parallel, it might zap other tcpdump
> instances as well and not just the one spawned by this script.
>
> > +tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q=
 FTP
>
> Not sure why the above is needed.  Isn't the 'cmp' enough to see
> if the ftp xfer worked?
>
> > +assert_pass "assert FTP traffic NATed"
> > +
> > +cmp "$INFILE" "$OUTFILE"
>
> ... because if there is a problem with the helper, then the cmp
> ought to fail?
>

