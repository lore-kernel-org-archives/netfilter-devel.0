From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH v3] extensions: libxt_hashlimit: fix uint64_t printf formats
Date: Mon, 29 May 2017 14:11:39 +0200
Message-ID: <CAF1oqRCC+GCYh5vXWDRsen=7vRhAfN3n_vXrL3jTO1AmLMRZEg@mail.gmail.com>
References: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com> <20170529120208.GA11167@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:35893 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdE2MLk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:11:40 -0400
Received: by mail-yb0-f178.google.com with SMTP id 130so14260503ybl.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 05:11:40 -0700 (PDT)
In-Reply-To: <20170529120208.GA11167@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 2:02 PM, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> On Wed, May 24, 2017 at 09:13:58AM +0200, Alin Nastac wrote:
>> From: Alin Nastac <alin.nastac@gmail.com>
>>
>> The remaining %llu formats are used for unsigned long long values.
>
> Hm, still problems here:
>
> libxt_hashlimit.c: In function =E2=80=98hashlimit_mt_print=E2=80=99:
> libxt_hashlimit.c:739:3: warning: format =E2=80=98%lu=E2=80=99 expects ar=
gument of type =E2=80=98long unsigned int=E2=80=99, but argument 2 has type=
 =E2=80=98__u64=E2=80=99 [-Wformat=3D]   printf(" burst %"PRIu64, cfg->burs=
t);
>    printf(" burst %"PRIu64, cfg->burst);
>    ^
> libxt_hashlimit.c: In function =E2=80=98hashlimit_mt_save=E2=80=99:
> libxt_hashlimit.c:849:3: warning: format =E2=80=98%lu=E2=80=99 expects ar=
gument of type =E2=80=98long unsigned int=E2=80=99, but argument 2 has type=
 =E2=80=98__u64=E2=80=99 [-Wformat=3D]
>    printf(" --hashlimit-burst %"PRIu64, cfg->burst);

That's odd, burst field of hashlimit_cfg2 struct is supposed to be an
__u64 integer (see include/linux/netfilter/xt_hashlimit.h line 68).
Probably you include the wrong header file.
