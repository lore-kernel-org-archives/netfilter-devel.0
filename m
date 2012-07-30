From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Building iptables from source with kernel source
Date: Mon, 30 Jul 2012 14:32:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207301429050.25013@frira.zrqbmnf.qr>
References: <1343646082.3347.7.camel@localhost>  <alpine.LNX.2.01.1207301314470.23976@frira.zrqbmnf.qr> <1343650307.3347.12.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50654 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab2G3Mc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:32:27 -0400
In-Reply-To: <1343650307.3347.12.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-07-30 14:11, Arif Hossain wrote:

>On Mon, 2012-07-30 at 13:58 +0200, Jan Engelhardt wrote:
>> On Monday 2012-07-30 13:01, Arif Hossain wrote:
>> 
><snip>
>> iptables is independent of any particular kernel tree. Copy (or
>> symlink) your file into <iptables>/include/linux/netfilter, that is
>> easiest.
>> 
>
>I've thought this easy way out actually. But i just hate the manual
>copying of same file. If i update something in one, i will have to
>remember to copy it before building it,because build will be ok with old
>file. That may lead to undefined behavior.
>
>Not a great fan of symlinks either.
>
><snip>
>
>> That is too unspecified to derive any cause.
>> (Also note that ksource uses the source dir, not the include dir.)
>
>Error message is trivial, "can not find file <xt_mymatch.h>.

That is because you are supposed to

  #include  <linux/netfilter/xt_mymatch.h>

provided the file is in

  $kerneldir/include/linux/netfilter/  or
  $iptablesinclude/include/linux/netfilter/

Looking at the existing extensions can help ;)

