From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Sat, 7 Jul 2012 18:23:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207071821560.17542@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
 <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
 <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54656 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2GGQXf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 12:23:35 -0400
In-Reply-To: <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 7 Jul 2012, Jozsef Kadlecsik wrote:

> I wait for a better solution, which does not produce different results 
> depending on the "in/out" or "src/dst" syntax, for all set types, 
> including the list of sets.

To make sure I'm not misunderstood, I have to add to the last sentence: 
"...and where both syntax is accepted".

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
