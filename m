From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: tc ipt action
Date: Sun, 16 Dec 2012 15:35:10 -0500
Message-ID: <50CE307E.40304@mojatatu.com>
References: <50C4821D.5090206@gmail.com> <50C9B4BB.9060609@mojatatu.com> <50CCE961.5050204@mojatatu.com> <20121216002755.GA11773@1984> <alpine.LNX.2.01.1212160144110.26218@nerf07.vanv.qr> <50CDA5BE.2080800@mojatatu.com> <alpine.LNX.2.01.1212161815310.27614@nerf07.vanv.qr> <50CE0921.7060306@mojatatu.com> <alpine.LNX.2.01.1212161850530.27614@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Yury Stankevich <urykhy@gmail.com>, shemonc@gmail.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41577 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LPUfN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:35:13 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so8340338ieb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Dec 2012 12:35:13 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1212161850530.27614@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12-12-16 01:59 PM, Jan Engelhardt wrote:
>
>
> A certainly safe bet would be to write, at the top of tc/m_xt.c,
>
> #if XTABLES_VERSION_CODE > 9
> #	error Someone call the guy who changed iptables and \
> 		make him fix it^W^W^W^W say you need help.
> #endif
>

Excellent idea ;->


> The following is a rough, it-compiles, untested never-run, draft of a
> module. The vision here is that userspace only ever sends a chain
> name to the kernel. The git tree/branch for it is
>
> 	git://git.inai.de/linux xt2-pktsched
>
> commit 42c559c148cbbc22bf2cc29f2ad08bc330891838
>


I'll look at it later - very slow connection at the moment so cloning 
will take a while.

cheers,
jamal
