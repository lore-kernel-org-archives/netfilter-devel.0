From: Florian Westphal <fw@strlen.de>
Subject: Re: "random" syn packets dropped
Date: Mon, 21 Nov 2016 11:39:19 +0100
Message-ID: <20161121103919.GA22120@breakpoint.cc>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc>
 <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
 <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
 <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37480 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752075AbcKUKlz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 05:41:55 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> After a restart of the machine, this problem disappeared for 10 days,
> but unfortunately
> showed up again yesterday. Seems like net_dropmonitor does not catch
> this one, the
> only output I get is:
> 
> nf_hook_slow                       171                         1
>
> This is definately something you should look into. I would be glad to
> assist if there
> is anything I can do.

Maybe already fixed via

https://patchwork.ozlabs.org/patch/695586/
https://patchwork.ozlabs.org/patch/695587/
