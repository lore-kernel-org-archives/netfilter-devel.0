From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: "random" syn packets dropped
Date: Thu, 24 Nov 2016 19:36:52 +0100
Message-ID: <CAJO99T=UR0f7huHMChKvDUzc03hhVF0cazKCz810P+vK0JjHbw@mail.gmail.com>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc> <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
 <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
 <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com>
 <20161121103919.GA22120@breakpoint.cc> <CAJO99TkDRo-M_PpGEwbK1r7cxr_ZLdF7yBXZ95+SJXoj0732HA@mail.gmail.com>
 <20161124135606.GA990@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35812 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933887AbcKXSgx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 13:36:53 -0500
Received: by mail-yw0-f175.google.com with SMTP id i145so45515232ywg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 10:36:53 -0800 (PST)
In-Reply-To: <20161124135606.GA990@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, Pablo.

Seems I was too quick to post this message, we were hit by an attack
just after the
upgrade, and the problems was this time caused by conntrack_max.
Currently it seems to
work with the patches, but the next week or two will probably show.

-- 
Bj(/)rnar
