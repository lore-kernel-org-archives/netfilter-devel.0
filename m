From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables-addons link error
Date: Sat, 14 Apr 2012 15:42:08 +0100
Message-ID: <4F898CC0.6080806@googlemail.com>
References: <4F7BB331.7000808@googlemail.com> <alpine.LNX.2.01.1204050724100.6040@frira.zrqbmnf.qr> <4F7D7B8F.3000705@googlemail.com> <4F88E7D9.7000508@googlemail.com> <alpine.LNX.2.01.1204141007590.1110@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36117 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2DNOmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Apr 2012 10:42:12 -0400
Received: by wgbdr13 with SMTP id dr13so3880119wgb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Apr 2012 07:42:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1204141007590.1110@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> As a temporary mitigation, please set build_ECHO=n in the mconfig file.
>   
Will do, thanks. That will exclude the ECHO module from the final build 
I take it, right?

On a side note - since I am building/testing kernels for various 
purposes more often than compiling/building xta kernel modules (I am 
also pretty fed up with having to build/reinstall my buildsys packages 
every time I move to another kernel!), I decided to incorporate the xta 
kernel modules as a kernel patch instead of building them separately 
each time I build a kernel for testing.

I remember getting the above errors, but since it was the first time I 
have attempted to include the xta modules as a patch, I thought that I 
must be doing something wrong. In addition to the above errors I also 
got a separate error, which stemmed from one of the xta kernel modules 
(I think it was DNETMAP) using/depending on a separate .o/.so kernel 
file being built prior to it, hence a few other unresolved symbols 
during linking. It was the reason I abandoned this effort pretty quickly.

Has this been attempted before - to include the xta modules as part of 
the kernel? If there is an interest, I could dig in again to see what 
other linking errors was I getting - just let me know.
