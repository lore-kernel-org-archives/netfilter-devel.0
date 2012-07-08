From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 08 Jul 2012 20:43:33 +0100
Message-ID: <4FF9E2E5.3090306@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>	<alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu>	<4FF736FE.8030109@googlemail.com>	<alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu>	<4FF74868.3070303@googlemail.com>	<CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com>	<4FF74D5C.6060909@googlemail.com>	<alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu>	<4FF752F0.3010007@googlemail.com>	<alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>	<4FF765E7.6020809@googlemail.com>	<alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>	<4FF9851A.8080400@googlemail.com> <CAHo-Ooya+1H939TqppUcY+pwprOH34zi-jHtnsN+g522aJ3ctw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45963 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2GHTnn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:43:43 -0400
Received: by wgbdr13 with SMTP id dr13so10796219wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Jul 2012 12:43:42 -0700 (PDT)
In-Reply-To: <CAHo-Ooya+1H939TqppUcY+pwprOH34zi-jHtnsN+g522aJ3ctw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > Example: If list1 - list:set type of set has, say, 5 members: iface1 
> and iface2 - type hash:net,iface, and ipp1, ipp2 and ipp3 - type 
> hash:ip,port, then the following iptables statement:
>
> Fly on the wall comment: the fact you allow sets of objects of 
> different types seems like a design mistake.
>
Nope, that is the *real* beauty of list:set type of sets - you can 
mix-and-match to your heart's content! In ipset versions prior to 4, I 
think, there used to be a feature called "nesting" in sets, but it was 
fraud and later abandoned.
