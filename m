Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C57BE65
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 14:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641013; cv=none; b=U0M587lOkzGIxNUxduRuCjYMaDwsCPkvYgfbWYIUEtUzFaT2i/AmhenCBYeExRYZ2/3SBnC2mOFNKwWDGh7aQWOunea13T9YmVsylYKPfvkiVZmubhDjVzdZ27QYGL5Xcf8hPZ7LMU8okJDimDnpq/yesB8z6DiEVkJGLLq1qaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641013; c=relaxed/simple;
	bh=uApJ1I8X66StqREA7ocvq9PPVV+znXwGTaB1yZ8VOaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zg7ugXBs7UBkwdChE/dUedCtnL8N4LfoT0x53gMyFuRKOJ0kFsRXAPi7mZFnvTCi40y67JKjlJ9oN9kF/I1bXj7AnYDnVS/ImjXLq54OK0yr4RY5vvfo8OObvlxUFMVVfQOyKQUg0OwPwa1/bfuFP92AONcAfbOyTG5jfWZtv2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJe1tbZ7; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJe1tbZ7"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7d0a2220fb0so140216385a.3
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 07:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751641011; x=1752245811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRCf0sTJh++LR8RXVGgiwHaVDp4TVxPHFbiAxB16Ua8=;
        b=FJe1tbZ7ej9x1aanpiefUuKRpaVyHjEBA9KGOc4Y7E3eAkkwPOg9sxBfw+gf1nteK6
         TvF+gM80jl0sZtMJ1CSQ5kCovx4iJSXIrfI14A8p+/4VFh+9g3EdkXcp4U9G+sUpvfty
         5J0XvL0pJ87OHFsODkiNR71JPY3Pkg6y5mym07pnm9EGsMONyhphWFvqafKfnm23/YNc
         dNxC7SxWWe7A25ahbG3LF3VTiXtbcBUdI1ORpf2vO14PMrOqbVKJX6KzcPNiYaV2gluU
         yXjtr0eTknQKOI0zU28RZ7kn11VXHFZJmYIjfUW8Mp0WcsV3Kr2aiSK1Cc6XNcAKAPcJ
         9n9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751641011; x=1752245811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WRCf0sTJh++LR8RXVGgiwHaVDp4TVxPHFbiAxB16Ua8=;
        b=kqV8rhs2pq8k14bzSCY0iW4QkjRVf8fg1phcMiT1fjfKyYhvkDBUDrL84B4e3iS2eO
         ot1yDr+ngSsapdcnAiKgG5Sisz1kHxsEFpigfhG146hU8/qbEce2lSGpVBhOlwmnPvLg
         3x3X/SrJ7ryZOGV2naHIIZ5ey0t3qNbCIlH5n56CDzN5gKBddiGMjXiwBTlnJzpcWY9K
         bsLBPOsKz07F9SOnMs7Fw25tVvb9+e/WUUGBFtdo6l/jtAp0Q9Y2fOdHc39YfQX/rEiN
         XrIL75fOz6N+GOJa52vxKH0oHI0xcNL3WKZy4f9Nuv4LXD9ea11vXvB2slL0gpOoqZGi
         Sc5w==
X-Forwarded-Encrypted: i=1; AJvYcCUkGyGHTwpT00oCi/iU2WtOAJaTIqydd33nx9rhcqnwjzlbt3nTLdy0q8PfQks9e1R7Um838mAmdGv8+MQu+zU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVntQr9Y6O5uad7Vy0X3Ndb3sstDNSYh1c0+1UrervjoNaUHnR
	9z1Jfqxln41nEFEdH8REUVu1cujsBhcEZAZ3B7zaJlFXMajplYK0wKVtpr5CkrCr5AhzNFQbMYu
	FACEsgmxjCb5DhtCg+ALVQOTea2irTVE=
X-Gm-Gg: ASbGncttNO6rD2nxy1UVBnKTJFydKiK5dk3pdqvSMEkyuzeZbTYdC2gA5i2BxfIpC96
	nnZ4zJSosyZySuGDxPpTbmcURpP/Wm29evf04tVBmd3Pwjq6lnELTGVP77oKxOI6RVDFCBdUwoK
	9zkmtrVtdb4Z4wdhavWk4fI00TbGksvV+c0QBKiWTqCZU=
X-Google-Smtp-Source: AGHT+IHVpNbYOqTmPSz5HE/qkjzAIBppG8P04rKgo4wsJLOe1KbEJQe4AJuobz39o59FQSoViATcZgLyfP6Y5C+Ur9E=
X-Received: by 2002:a05:620a:44c9:b0:7d4:49fa:3c59 with SMTP id
 af79cd13be357-7d5df0f2a98mr292835485a.15.1751641010773; Fri, 04 Jul 2025
 07:56:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com> <20250704113947.676-3-dzq.aishenghu0@gmail.com>
In-Reply-To: <20250704113947.676-3-dzq.aishenghu0@gmail.com>
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Date: Fri, 4 Jul 2025 22:56:39 +0800
X-Gm-Features: Ac12FXxjK4z0-NlNh3gZmUZk7-jhrZdUWMUVWPTNCloxp69_mJ00gH8Yn7HUepI
Message-ID: <CAFmV8NceKA_0uf6avxhqPVcQUkOedQGAnDU8SX+2QDJWdpbmBA@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] src: do not print unnecessary space for the
 synproxy object
To: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>, 
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 7:40=E2=80=AFPM Zhongqiu Duan <dzq.aishenghu0@gmail.=
com> wrote:
>
> If timestamp is not enabled in the synproxy object, an additional space
> will be print before the sack-perm flag.
>
> Before this patch:
>
> table inet t {
>         synproxy s {
>                 mss 1460
>                 wscale 8
>                  sack-perm
>         }
> }
>
> After this patch:
>
> table inet t {
>         synproxy s {
>                 mss 1460
>                 wscale 8
>                 sack-perm
>         }
> }
>
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> ---
>  src/rule.c                             | 4 +++-
>  tests/shell/testcases/json/single_flag | 4 ++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/src/rule.c b/src/rule.c
> index c0f7570e233c..af3dd39c69d0 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1951,7 +1951,9 @@ static void obj_print_data(const struct obj *obj,
>                 }
>                 if (flags & (NF_SYNPROXY_OPT_TIMESTAMP | NF_SYNPROXY_OPT_=
SACK_PERM)) {
>                         nft_print(octx, "%s%s%s", opts->nl, opts->tab, op=
ts->tab);
> -                       nft_print(octx, "%s %s", ts_str, sack_str);
> +                       nft_print(octx, "%s%s%s", ts_str,
> +                                 flags & NF_SYNPROXY_OPT_TIMESTAMP ? " "=
 : "",
> +                                 sack_str);
>                 }
>                 nft_print(octx, "%s", opts->stmt_separator);
>                 }

Emmm, this will add an additional space after the timestamp if the timestam=
p
is set but sack-perm does not.

It could be:
---
diff --git a/src/rule.c b/src/rule.c
index c0f7570e233c..3761e05a22e3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1950,8 +1950,10 @@ static void obj_print_data(const struct obj *obj,
                        nft_print(octx, "wscale %u", obj->synproxy.wscale);
                }
                if (flags & (NF_SYNPROXY_OPT_TIMESTAMP |
NF_SYNPROXY_OPT_SACK_PERM)) {
+                       bool space =3D ((flags & NF_SYNPROXY_OPT_TIMESTAMP)=
 &&
+                                     (flags & NF_SYNPROXY_OPT_SACK_PERM));
                        nft_print(octx, "%s%s%s", opts->nl, opts->tab,
opts->tab);
-                       nft_print(octx, "%s %s", ts_str, sack_str);
+                       nft_print(octx, "%s%s%s", ts_str, space ? " "
: "", sack_str);

                }
                nft_print(octx, "%s", opts->stmt_separator);
                }

> diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcas=
es/json/single_flag
> index f0a608ad8412..b8fd96170a33 100755
> --- a/tests/shell/testcases/json/single_flag
> +++ b/tests/shell/testcases/json/single_flag
> @@ -157,13 +157,13 @@ STD_SYNPROXY_OBJ_1=3D"table ip t {
>         synproxy s {
>                 mss 1280
>                 wscale 64
> -                sack-perm
> +               sack-perm
>         }
>  }"
>  JSON_SYNPROXY_OBJ_1=3D'{"nftables": [{"table": {"family": "ip", "name": =
"t", "handle": 0}}, {"synproxy": {"family": "ip", "name": "s", "table": "t"=
, "handle": 0, "mss": 1280, "wscale": 64, "flags": "sack-perm"}}]}'
>  JSON_SYNPROXY_OBJ_1_EQUIV=3D$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<=
< "$JSON_SYNPROXY_OBJ_1")
>
> -STD_SYNPROXY_OBJ_2=3D$(sed 's/ \(sack-perm\)/timestamp \1/' <<< "$STD_SY=
NPROXY_OBJ_1")
> +STD_SYNPROXY_OBJ_2=3D$(sed 's/\(sack-perm\)/timestamp \1/' <<< "$STD_SYN=
PROXY_OBJ_1")
>  JSON_SYNPROXY_OBJ_2=3D$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timesta=
mp", \2]/' <<< "$JSON_SYNPROXY_OBJ_1")
>
>  back_n_forth "$STD_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1"
> --
> 2.43.0
>
