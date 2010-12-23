From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 23:06:52 +0000
Message-ID: <4D13D60C.3020304@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> Just to illustrate:
>
> # ipset create test hash:ip,port                          
> # ipset add test 192.168.0.0/30,tcp:80-82                 
> # ipset list test                                         
> Name: test                                                                      
> Type: hash:ip,port                                                              
> Header: family inet hashsize 1024 maxelem 65536                                 
> Size in memory: 16888                                                           
> References: 0                                                                   
> Members:                                                                        
> 192.168.0.3,tcp:81                                                              
> 192.168.0.0,tcp:82                                                              
> 192.168.0.1,tcp:81                                                              
> 192.168.0.1,tcp:82                                                              
> 192.168.0.3,tcp:82                                                              
> 192.168.0.0,tcp:80                                                              
> 192.168.0.2,tcp:80                                                              
> 192.168.0.0,tcp:81                                                              
> 192.168.0.1,tcp:80                                                              
> 192.168.0.2,tcp:82                                                              
> 192.168.0.2,tcp:81                                                              
> 192.168.0.3,tcp:80                                                              
>   
Wow! telepathy must be my forte!!! That's just the example I emailed you 
to see if I understand you correctly!

OK, does that differ if I have hash:net,port set (I presume when listing 
with ipset -L you will show the net ranges - 
192.168.0.0-192.168.0.0,tcp:80-82), is that right?

