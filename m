From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Wed, 22 Dec 2010 11:59:15 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47093 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0LVK7Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:59:16 -0500
In-Reply-To: <4D0E3B34.7090105@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 19 Dec 2010, Mr Dash Four wrote:

> > > Wouldn't you agree that this is a better solution than registering 
> > > twice as many members in a particular set in order to get the match 
> > > I need?
> > 
> > Given that ports are only meaningful in the context of a protocol I don't
> > think that makes sense.
> You are mistaken! I've never actually stated, nor implied, that protocols are
> 'meaningless' when ports are specified or used - I stated that I am not
> interested in *matching* the protocol as for me this part of the match is
> irrelevant - there are plenty of examples where a particular service can
> employ either tcp or udp protocol on the same port - see below for examples.

I could not come up with a good solution. It is not possible to avoid
double lookup in the set if the elements may have (say hash:ip,port type 
of set) the forms:

ipaddr,tcp:port
ipaddr,udp:port
ipadd,tcpudp:port

But if the double-lookup is required, then better add all tcp and udp port 
variants and go with a single-lookup.

Or if you have uniform ports for all elements, you can use two set 
matches:

ipset create hash:ip ipaddrs
ipset create bitmap:port ports

... -m set --match-set ipaddrs dst -m set --match-set ports dst ...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
