From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: "random" syn packets dropped
Date: Thu, 24 Nov 2016 14:37:30 +0100
Message-ID: <CAJO99TkDRo-M_PpGEwbK1r7cxr_ZLdF7yBXZ95+SJXoj0732HA@mail.gmail.com>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc> <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
 <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
 <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com> <20161121103919.GA22120@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32899 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938650AbcKXNhr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:37:47 -0500
Received: by mail-yw0-f181.google.com with SMTP id r204so39490097ywb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 05:37:31 -0800 (PST)
In-Reply-To: <20161121103919.GA22120@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, Florian

I applied the patches to net-next, but unfortunately this did fix the
bug I am seeing,
in addition, now the bug seems to appear immediately (also with
previous kernel),
not after ~10 days as I have seen before.

-- 
Bj(/)rnar
