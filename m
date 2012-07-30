From: Arif Hossain <aftnix@gmail.com>
Subject: Re: Building iptables from source with kernel source
Date: Mon, 30 Jul 2012 18:11:47 +0600
Message-ID: <1343650307.3347.12.camel@localhost>
References: <1343646082.3347.7.camel@localhost>
	 <alpine.LNX.2.01.1207301314470.23976@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2G3MWZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:22:25 -0400
Received: by pbbrp8 with SMTP id rp8so9759622pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jul 2012 05:22:25 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207301314470.23976@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2012-07-30 at 13:58 +0200, Jan Engelhardt wrote:
> On Monday 2012-07-30 13:01, Arif Hossain wrote:
> 
<snip>
> iptables is independent of any particular kernel tree. Copy (or
> symlink) your file into <iptables>/include/linux/netfilter, that is
> easiest.
> 

I've thought this easy way out actually. But i just hate the manual
copying of same file. If i update something in one, i will have to
remember to copy it before building it,because build will be ok with old
file. That may lead to undefined behavior.

Not a great fan of symlinks either.

<snip>

> That is too unspecified to derive any cause.
> (Also note that ksource uses the source dir, not the include dir.)

Error message is trivial, "can not find file <xt_mymatch.h>.


-- 
Cheers

aft
aftnix@gmail.com

