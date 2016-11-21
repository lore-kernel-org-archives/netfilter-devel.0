From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: "random" syn packets dropped
Date: Mon, 21 Nov 2016 11:19:31 +0100
Message-ID: <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc> <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
 <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:35563 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbcKUKTd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 05:19:33 -0500
Received: by mail-yb0-f182.google.com with SMTP id d128so88848569ybh.2
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2016 02:19:32 -0800 (PST)
In-Reply-To: <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again.

After a restart of the machine, this problem disappeared for 10 days,
but unfortunately
showed up again yesterday. Seems like net_dropmonitor does not catch
this one, the
only output I get is:

nf_hook_slow                       171                         1

This is definately something you should look into. I would be glad to
assist if there
is anything I can do.

-- 
Bj(/)rnar
