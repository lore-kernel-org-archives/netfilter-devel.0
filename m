From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec) [part 2]
Date: Wed, 21 Mar 2012 13:50:59 -0700
Message-ID: <CAHo-OozsBkyQ-hq0Hkuef3uohemnHCh1qBo02By-kE5Rpt92Lg@mail.gmail.com>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
	<1332361663.9433.8.camel@edumazet-glaptop>
	<CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
	<1332362670.9433.9.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61585 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2CUUvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:51:00 -0400
Received: by obbeh20 with SMTP id eh20so943114obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Mar 2012 13:50:59 -0700 (PDT)
In-Reply-To: <1332362670.9433.9.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> True, but CLOEXEC on iptables... I mean... how is it mandatory ?

I'm not sure what you mean by mandatory.

iptables does potentially fork/exec modprobe to load modules.
That can cause a selinux 'domain'/'role'/whatever-it-is-called crossing.
You can do automated inspection of what gets carried across such
privilege changes and any unexpected open file descriptors flag
problems, patches like this cut down on the noise.
