From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 23:56:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
 <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46989 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0LWW43 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:56:29 -0500
In-Reply-To: <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Dec 2010, Jozsef Kadlecsik wrote:

> On Thu, 23 Dec 2010, Mr Dash Four wrote:
> 
> > > The implementation behind ipset looks up the  (ipaddr, proto, port) triple
> > > in one step. Such packing don't work there.
> > >   
> > If that's the case how do you lookup IP address and port ranges then?
> 
> IP address and port ranges are exploded and the elements are inserted 
> one-by-one. And the exploded ranges are *not* converted back to ranges 
> when listing/saving the sets. At the bitmap types the ranges could be 
> converted back (not done yet), at the hash types it's not possible.

Just to illustrate:

# ipset create test hash:ip,port                          
# ipset add test 192.168.0.0/30,tcp:80-82                 
# ipset list test                                         
Name: test                                                                      
Type: hash:ip,port                                                              
Header: family inet hashsize 1024 maxelem 65536                                 
Size in memory: 16888                                                           
References: 0                                                                   
Members:                                                                        
192.168.0.3,tcp:81                                                              
192.168.0.0,tcp:82                                                              
192.168.0.1,tcp:81                                                              
192.168.0.1,tcp:82                                                              
192.168.0.3,tcp:82                                                              
192.168.0.0,tcp:80                                                              
192.168.0.2,tcp:80                                                              
192.168.0.0,tcp:81                                                              
192.168.0.1,tcp:80                                                              
192.168.0.2,tcp:82                                                              
192.168.0.2,tcp:81                                                              
192.168.0.3,tcp:80                                                              
                      
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
