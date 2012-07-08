From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 08 Jul 2012 23:10:52 +0100
Message-ID: <4FFA056C.8000709@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu> <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu> <alpine.DEB.2.00.1207071821560.17542@blackhole.kfki.hu> <4FF9852C.7080201@googlemail.com> <alpine.DEB.2.00.1207082051150.19776@blackhole.kfki.hu> <4FF9D97D.7040309@googlemail.com> <alpine.DEB.2.00.1207082104290.19776@b
 lackhole.kfki.hu> <4FF9DB46.5000302@googlemail.com> <alpine.DEB.2.00.1207082225250.20080@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44669 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2GHWLD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:11:03 -0400
Received: by wgbds11 with SMTP id ds11so2154269wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Jul 2012 15:11:01 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207082225250.20080@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> "src,src" != "src,dst", but
>
> with your patches in some cases 
>
> "src,in" == "src,src" or "src,in" != "src,src"
>   
Could you provide me with an example please? I am intrigued!

>> Avoid what exactly? Using 'in' or 'out' in list:set types?
>>     
>
> For example. That's a possible solution.
>   
So, in other words, what you are actually getting at, is that you wish 
to restrict the use of 'in' and 'out' options only for hash:net,iface 
types because you are not happy with the use of 'in'/'out' in any other 
set types, list:set in particular? Have I understood this correctly then?
