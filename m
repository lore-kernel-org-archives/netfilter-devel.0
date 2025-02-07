Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E83238D52;
	Fri,  7 Feb 2025 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940613; cv=none; b=KZi51QzqopvXhclLTARI60DAMzcoyNpbAeqpijXXSMFmiu7Rnsp6+PHOo+1is3omNKw70amKSC6bRcC1CRTTghUWynZSlMf2Su9nDN8Am4ro65sFYuu338V6htDb5PkxTwquSw58E36NLW2+emyBkvbyS1hcsUlaecMwLDDEgBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940613; c=relaxed/simple;
	bh=NrHZbm4D7MN3xgdaN7m8W+tD+OE5P84+cGGSCV7S0Rc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=UDLG+elNBchhdLh9Q5Tyuk7joRP5qao0u8u0Ctnc14T6r4JccWSIc1Y63/Lkgswgx2f4dMrn9uM7hv/MIi6VxwQOagi6X/1C8o17sekVJ7aDEYgg2mdeMogAZ6Hxr8xAK9osrqSKcRb93cMKKvTr9Zv0qDNY03jjNnnSNK0s4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfnlGyN/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfnlGyN/"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361dc6322fso14835545e9.3;
        Fri, 07 Feb 2025 07:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738940609; x=1739545409; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0lTzVJ+TWQ7/8INdPGsdHa8PXZP40c/m3GSbduEZ77Y=;
        b=gfnlGyN/P2+2tsAXM9gazbzXJWcfbxgTBYy2Bm5CXeu7B9SvcdY9jInx69OxuNmbik
         j6MHuJifQ0e2UOAU6l+Q7ZBB+B4NPNtLgMA++f3wS3FdNfAK8Wmf9ev+m4kMkctJiG+m
         ZS0mHdlDO/AU9edDLc6m1H3wnoUNHrz6BphuuzVQg9tIIKgUhIwpX2sGmwS3k4De3vrj
         hu3uyeINE5n2FOUN1uvWhCd1pkFD4EwpfaMC6dAUE0Wco1IfcPSaJRetbWFgqJfPxA/o
         fHpggtOOUfxgG52o0F/z0ybJELb/r7gMVPloe91JPvE0fN0TpNG9QuMeXLGitGEuETPa
         ZIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738940609; x=1739545409;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lTzVJ+TWQ7/8INdPGsdHa8PXZP40c/m3GSbduEZ77Y=;
        b=DJTuKHcUwYJuru4eVIu1Ybzuay8G/H6An//0QIGjfbf5Bd5DUGIZf3hBta34umX/Md
         KuCHTC1IH7GGIyCTTa5LfSyvVYOVmcnlqtcu7lgwAnNFs4Bg279BvcRNqVqqrJOdvgMj
         m+yaeOJcdiME85CK6eaQ88pH5zYss8vA8rniryj4uGVK5nBNyCRjQ20ad5OPqdp8o40A
         qBgC9cc11wcbYcnRL36sxGi+ZPzt4+ODAM5fsrcdjWDALgaxXyPICHFKi/mq64i6igh1
         5e51ge7pwJ2cr8QEnEL9Bl7KQjO//4g89Kl4gD2edflw7dTSESZ+BefkKuSbJQNF8d1x
         BFHA==
X-Forwarded-Encrypted: i=1; AJvYcCX+fqX8kaw9QnzSYGv9WJgUXglcEZfGri3cC9+8fLtSRdkMglJ/xRo8PwV+MLtbbyMUNLzb1ZY+4MJ2jfapL0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ8ro9Vuus08Ah1yOXe/IuE00en5V+DCIhvOpG/NsbJEb7oHXM
	a4sHvClsEYr4p8NhSWqa1dmS/S/+LU/Wn/S7Puq4CgeIGafV+wWEJ+Ke3A==
X-Gm-Gg: ASbGnct9CVNMqv607XNPUP7lBrlc3t96Bm/4DVykBJkYyO88xVbruXIC3H+Iefxf9RR
	wRtvH2tDgpsjROQDd6KhDPSvwBwr5iOzdoGesllOJv2ZvZVZj8jlQjVrmv1wHS8BuSEJOi8wDKp
	Po2blsYshb9xf3MlVQ3kA7bABHSvl79Yb26lEiru70C1FwkA/DjsprgkdwM3oeak7nebEfysSdf
	hRqc93JoFyaA/Fhz1d2Fa7rLZSvP6tG3VE685auJ9f/ygM5jCl4sS3E+Isr62XM1JFTPHxs2OkK
	qlzkmZTY112jgKEMut4y/ASuftEQ
X-Google-Smtp-Source: AGHT+IGyCbPw5FnxaB5ZBty1lGHOaBUlF5mkCw05DgmgRdX9UbGCzsC0e3nqIPV8s8hxqMR+xtpv5Q==
X-Received: by 2002:a05:600c:55d9:b0:431:54d9:da57 with SMTP id 5b1f17b1804b1-4392508f359mr30447275e9.30.1738940608833;
        Fri, 07 Feb 2025 07:03:28 -0800 (PST)
Received: from imac ([2a02:8010:60a0:0:ac43:c7d9:c802:8ec3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dca004esm56489305e9.13.2025.02.07.07.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 07:03:28 -0800 (PST)
From: Donald Hunter <donald.hunter@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>,  <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] netlink: specs: add ctnetlink dump and stats
 dump support
In-Reply-To: <20250207120516.17002-1-fw@strlen.de> (Florian Westphal's message
	of "Fri, 7 Feb 2025 13:05:11 +0100")
Date: Fri, 07 Feb 2025 15:03:14 +0000
Message-ID: <m2ed09yez1.fsf@gmail.com>
References: <20250207120516.17002-1-fw@strlen.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Florian Westphal <fw@strlen.de> writes:

> This adds support to dump the connection tracking table
> ("conntrack -L") and the conntrack statistics, ("conntrack -S").
>
> Example conntrack dump:
> tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/ctnetlink.yaml --dump ctnetlink-get
> [{'id': 59489769,
>   'mark': 0,
>   'nfgen-family': 2,
>   'protoinfo': {'protoinfo-tcp': {'tcp-flags-original': {'flags': {'maxack',
>                                                                    'sack-perm',
>                                                                    'window-scale'},
>                                                          'mask': set()},
>                                   'tcp-flags-reply': {'flags': {'maxack',
>                                                                 'sack-perm',
>                                                                 'window-scale'},
>                                                       'mask': set()},
>                                   'tcp-state': 'established',
>                                   'tcp-wscale-original': 7,
>                                   'tcp-wscale-reply': 8}},
>   'res-id': 0,
>   'secctx': {'secctx-name': 'system_u:object_r:unlabeled_t:s0'},
>   'status': {'assured',
>              'confirmed',
>              'dst-nat-done',
>              'seen-reply',
>              'src-nat-done'},
>   'timeout': 431949,
>   'tuple-orig': {'tuple-ip': {'ip-v4-dst': '34.107.243.93',
>                               'ip-v4-src': '192.168.0.114'},
>                  'tuple-proto': {'proto-dst-port': 443,
>                                  'proto-num': 6,
>                                  'proto-src-port': 37104}},
>   'tuple-reply': {'tuple-ip': {'ip-v4-dst': '192.168.0.114',
>                                'ip-v4-src': '34.107.243.93'},
>                   'tuple-proto': {'proto-dst-port': 37104,
>                                   'proto-num': 6,
>                                   'proto-src-port': 443}},
>   'use': 1,
>   'version': 0},
>  {'id': 3402229480,
>
> Example stats dump:
> tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/ctnetlink.yaml --dump ctnetlink-stats-get
> [{'chain-toolong': 0,
>   'clash-resolve': 3,
>   'drop': 0,
>  ....
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Documentation/netlink/specs/ctnetlink.yaml | 582 +++++++++++++++++++++
>  1 file changed, 582 insertions(+)
>  create mode 100644 Documentation/netlink/specs/ctnetlink.yaml

Can you change the filename to conntrack.yaml so that it matches the
family name. This helps ./tools/net/ynl/pyynl/cli.py --list-families
which is based on the filenames. It's also redundant to say netlink in
the filename since it is in the netlink/specs directory.

...

> +attribute-sets:
> +  -
> +    name: ctnetlink-counter-attrs

Not sure the ctnetlink- prefix is needed in all the attribute-set names.
I'd suggest keeping a prefix only for the toplevel attriubtes but change
the prefix to conntrack- for consistency.

...

> +  -
> +    name: ctnetlink-attrs
> +    attributes:

...

> +operations:
> +  enum-model: directional
> +  list:
> +    -
> +      name: ctnetlink-get

My preference is to drop the ctnetlink- prefix from the op names, to be
consistent with the other netlink specs.

> +      doc: get / dump entries
> +      attribute-set: ctnetlink-attrs
> +      fixed-header: nfgenmsg
> +      do:
> +        request:
> +          value: 0x101
> +          attributes:
> +            - name
> +        reply:
> +          value: 0x100
> +          attributes:
> +            - name

The usage is not specified correctly. You give a dump example so there
should be a dump: definition. The reply attributes should be enumerated.
If do: is supported then the request attributes should be enumerated.

Same for stats-get below.

> +    -
> +      name: ctnetlink-stats-get
> +      doc: dump pcpu conntrack stats
> +      attribute-set: ctnetlink-stats-attrs
> +      fixed-header: nfgenmsg
> +      do:
> +        request:
> +          value: 0x104
> +          attributes:
> +            - name
> +        reply:
> +          value: 0x104
> +          attributes:
> +            - name
> +

Thanks,
Donald.
