From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 22:04:48 +0100
Message-ID: <4FF752F0.3010007@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58217 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2GFVE4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:04:56 -0400
Received: by wgbdr13 with SMTP id dr13so9657578wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 14:04:55 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Do you deliberately close your eyes? In the two rules
>   
Explain the above comment please?

> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> the underlying set types "decide" how to act to "src/in", when actually 
> "src" == "in". I hear you shouting: FOR HASH:NET,IFACE ONLY. Right. But 
> "list1" is a list type of set, not hash:net,iface. Still, the result is 
> different.
>   
Whoever produces the above statements is making a concious decision on 
what to use/deploy! I am repeating this for, I don't know, a third time 
maybe - what my patch series are offering is a choice. If you, or 
anybody else wishes to continue to use 'src' or 'dst' (including for 
interface matching), then so be it, you are completely free to do that - 
I am not forcing you, or anyone to do otherwise.

If, on the other hand, I, or anybody else, is not entirely comfortable 
with using 'src' or 'dst' for interface matching and prefer to use 'in' 
or 'out' instead, then so be it - the choice is there.

