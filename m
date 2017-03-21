From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd: add +1 char for null char
Date: Tue, 21 Mar 2017 21:54:53 +0100
Message-ID: <1490129693.2157.21.camel@regit.org>
References: <1489998667-15183-1-git-send-email-ardeleanalex@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
To: Alexandru Ardelean <ardeleanalex@gmail.com>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:54437 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933663AbdCUUzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 16:55:16 -0400
In-Reply-To: <1489998667-15183-1-git-send-email-ardeleanalex@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Thanks for the report and the patch. I'm not sure of your
implementation. Can you test with the patch to follow ?

On Mon, 2017-03-20 at 10:31 +0200, Alexandru Ardelean wrote:
> This is a bit zealous to fix like this, but it seems to work.
> 
> The crash was reproduced on ppc32, with GCC 5.4 & musl libc 1.1.16.
> 
> And also on LEDE (mips_24kc and ARM):
> https://github.com/openwrt/packages/issues/4123
> https://github.com/openwrt/packages/issues/4090
> 
> I personally saw it on ppc32.
> The offending code was in `pluginstance_alloc_init()` line 671:
> ```
> memcpy(pi->id, pi_id, sizeof(pi->id));
> ```

Thanks in advance,
-- 
Eric Leblond <eric@regit.org>
