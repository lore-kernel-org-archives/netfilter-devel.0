From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Mon, 09 Jul 2012 23:05:08 +0100
Message-ID: <4FFB5594.9040700@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu> <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu> <alpine.DEB.2.00.1207071821560.17542@blackhole.kfki.hu> <4FF9852C.7080201@googlemail.com> <alpine.DEB.2.00.1207082051150.19776@blackhole.kfki.hu> <4FF9D97D.7040309@googlemail.com> <alpine.DEB.2.00.1207082104290.19776@blackhole.kfki.hu> <4FF9DB46.5000302@googlemail.com> <alpine.DEB.2.00.1207082225250.20080@blackhole.kfki.hu> <4FFA056C.8000709@googlemail.com> <alp
 ine.DEB.2.00.1207090014450.20627@blackhole.k fki.hu> <4FFA08CE.1090406@googlemail.com> <alpine.DEB.2.00.1207090035050.20788@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44090 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2GIWFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:05:11 -0400
Received: by wgbdr13 with SMTP id dr13so11845738wgb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jul 2012 15:05:10 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207090035050.20788@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> In other words:
>> 1. For hash:net,iface the possible options should be 'in', 'out', 'src' and
>> 'dst'; and
>> 2. For all other sets, including list:set the only available options should be
>> 'src' and 'dst'. Have I understood this correctly then?
> 
> Yes, that looks OK.
I'll submit an alternative version of the patches soon, with the above restrictions applied to see if that makes you happy.
