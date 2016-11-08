From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: "random" syn packets dropped
Date: Tue, 8 Nov 2016 20:26:42 +0100
Message-ID: <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36558 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbcKHT0n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 14:26:43 -0500
Received: by mail-yw0-f173.google.com with SMTP id l124so188971766ywb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Nov 2016 11:26:43 -0800 (PST)
In-Reply-To: <20161108140857.GE24908@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-11-08 15:08 GMT+01:00 Florian Westphal <fw@strlen.de>:
> Bj=C3=B8rnar Ness <bjornar.ness@gmail.com> wrote:
>> * this issue seem to suddenly appeared, is this a known bug?
>
> No.
>
>> * hint? All connections from the client is established from the same
>> source port.
>
> can you show conntrack -S output?

cpu=3D0       searched=3D121227494 found=3D39167580 new=3D304 invalid=3D735=
9
ignore=3D323276 delete=3D58920554 delete_list=3D58920526 insert=3D304
insert_failed=3D0 drop=3D0 early_drop=3D0 error=3D7359 search_restart=3D0
cpu=3D1       searched=3D769896688 found=3D3223427856 new=3D1824070235
invalid=3D99676863 ignore=3D9456795 delete=3D1803700815
delete_list=3D1731666319 insert=3D1745298679 insert_failed=3D3 drop=3D3
early_drop=3D0 error=3D3674946 search_restart=3D2
cpu=3D2       searched=3D488983917 found=3D2793077405 new=3D1800015302
invalid=3D97556206 ignore=3D9424173 delete=3D1789649391
delete_list=3D1705077976 insert=3D1724463703 insert_failed=3D9 drop=3D9
early_drop=3D0 error=3D3748383 search_restart=3D2
cpu=3D3       searched=3D449939710 found=3D3134174470 new=3D1839530428
invalid=3D99941483 ignore=3D9734373 delete=3D1811219076
delete_list=3D1735637482 insert=3D1761666050 insert_failed=3D6 drop=3D6
early_drop=3D0 error=3D3914932 search_restart=3D2

> Is nat in use?

yes, but not on there connections

> Does 'perf script net_dropmonitor' show anything?

Sorry. no ftrace

--=20
Bj(/)rnar
