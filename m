Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iYPrrBUK"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973C411B
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 05:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702559744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LyWfnZEN1tVSDwQMpN/vTewfb/SK8X0Fjpym6QA8lMo=;
	b=iYPrrBUKFJPdV/p63bHSQaL0GPPkDBvNx/wr9GMbhLErx1gYZPgMuqEl6CCzDGtw5sF5Mx
	98J4aroSndF0SXPgbAC559wLeEr+8cdsUjJGl5FwOnQq40jpG+PFTTle0wMj7uEtUZSTCb
	WUR8BjKlx0iVBm3o3lbJB1T8s4azur4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-vFw7jVxjORKUktsYlZ88Ww-1; Thu, 14 Dec 2023 08:15:43 -0500
X-MC-Unique: vFw7jVxjORKUktsYlZ88Ww-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50bef1751a4so1284506e87.1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 05:15:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702559741; x=1703164541;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LyWfnZEN1tVSDwQMpN/vTewfb/SK8X0Fjpym6QA8lMo=;
        b=U8UlTqaBLlfrqW+7yD5DrVlo1+12HtApxCUXbDcdwWHoLv5VJSKrjSNu+1i4F6rU5A
         155ZveRPBhfXFu5sJRp97iDkke3XuUihzDINZ3t0TK+L11QQXihoeydAJs11hfz00u1x
         l3fBg4b3MK7S79tI7F6LBx9q7+6QcfPuu098wutbW6aTtxGrspy30oRsjjrmP6j1X8OH
         +9H5+01njYK6M70/29TM0fdMK/0xtpa4L2Pw4eFJrnCAkpW4qFU5JC62NX6z78eUU1hl
         oHGIjDY0LgWhu/898becqtWuc56EibI3UNqU9nRLpAfh2Evc1CF4r9DBcMLOZ7sCYeDv
         H/Gg==
X-Gm-Message-State: AOJu0YwioK2hnLn5hedW/WGRwJdH2AL4auBfV5HqXTfEopXRqBiu8dx9
	9yurUBQKkO80R36XzfnGWgXR/zz3ExFT6hLsnZdlb9bZjYOSONMXX2nQ2r3yEiLEcsx+SgevXVE
	LVeI551YEvZS4ei22MooGktUM9aEwNc+wdxoq
X-Received: by 2002:a19:675e:0:b0:50b:ed57:758c with SMTP id e30-20020a19675e000000b0050bed57758cmr8028749lfj.1.1702559741247;
        Thu, 14 Dec 2023 05:15:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1pRZ2976wb/KCnEY2+FRKJ6XH4kONe6fYzLFuAFg28NlYv++bAHeQvN4rtK7zBjXrpdoTGw==
X-Received: by 2002:a19:675e:0:b0:50b:ed57:758c with SMTP id e30-20020a19675e000000b0050bed57758cmr8028740lfj.1.1702559740859;
        Thu, 14 Dec 2023 05:15:40 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id ps3-20020a170906bf4300b00a1dd8945d31sm9329623ejb.34.2023.12.14.05.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 05:15:40 -0800 (PST)
Message-ID: <282355154670b7b48076caf4661459f218544419.camel@redhat.com>
Subject: Re: [PATCH v2 nft] initial support for the afl++ (american fuzzy
 lop++) fuzzer
From: Thomas Haller <thaller@redhat.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date: Thu, 14 Dec 2023 14:15:39 +0100
In-Reply-To: <20231214125025.8729-1-fw@strlen.de>
References: <20231214125025.8729-1-fw@strlen.de>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 (3.50.2-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,


> +AM_CONDITIONAL([BUILD_AFL], [test "x$enable_fuzzer" =3D xyes])
> +AS_IF([test "x$enable_fuzzer" !=3D xno], [
> +	AC_DEFINE([HAVE_FUZZER_BUILD], [1], [Define if you want to
> build with fuzzer support])
> +	], [])


could you always define HAVE_FUZZER_BUILD, and check with `#if
HAVE_FUZZER_BUILD`, instead of `#ifdef`.

The benefit is, that compiler will emit a warning, when `#if` is used
and the variable doesn't exist (e.g. due to a typo).


something like:

  HAVE_FUZZER_BUILD=3D0
  if [ "$enable_fuzzer" !=3D no ] ; then
      HAVE_FUZZER_BUILD=3D1
  fi
  AC_DEFINE_UNQUOTED([HAVE_FUZZER_BUILD], [$HAVE_FUZZER_BUILD], [Whether to=
 build with fuzzer support])




> diff --git a/include/afl++.h b/include/afl++.h
> new file mode 100644
> index 000000000000..28244dcaaf62
> --- /dev/null
> +++ b/include/afl++.h
> @@ -0,0 +1,49 @@
> +#ifndef _NFT_AFLPLUSPLUS_H_
> +#define _NFT_AFLPLUSPLUS_H_
> +
> +#include <nftables/libnftables.h>
> +#include <config.h>

<config.h> should always be included as very first in all sources. For
example, it brings `_GNU_SOURCE`, which enables certain features in
libc headers. If you define _GNU_SOURCE somewhere in the middle of a
list of #include, it becomes cumbersome to be sure which libc header
version we have.

Similarly, `src/afl++.c` also must include <config.h> as first.

But note, we should not actually include <config.h> at all. Instead,
`#include <nft.h>` as first (which takes care of getting this right).
Also, only include <nft.h> in C-sources (as first). Thereby, all C
sources can rely to have what <nft.h> provides. Furthermore, since
header files are only indirectly compiled by being included from C
sources, they also can rely on having <nft.h>.






I would avoid the "++" in filenames. E.g. it's a special character for
regexes (depending on regex syntax).

