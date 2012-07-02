From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Mon, 2 Jul 2012 15:26:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207021513540.4335@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
 <4FF04647.7060807@googlemail.com> <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu> <4FF04DDA.3020609@googlemail.com> <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu> <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz> <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
 <4FF19E01.6090400@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amos Jeffries <squid3@treenet.co.nz>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4FF19E01.6090400@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2 Jul 2012, Mr Dash Four wrote:

> > Maybe ASCII art helps better to explain the different views:
> > 
> > - Mr Dash Four
> > 
> >                      -----------
> >   pkt comes in ----- | machine | ----- pkt goes out
> >                    ^ ----------- ^
> >                  destination   source
> > 
> > - my view follows how the subsytem sees the interfaces
> > 
> >                              ------------------
> >   pkt comes in --- interface | ipset subsytem | interface --- pkt goes out
> >                            ^ ------------------ ^
> >                        source               destination
> > 
> >   
> How do you explain that the same "ipset subsystem" treats the IP address 
> of the "source" interface (according to your diagram above) as 
> "destination" when I match the same (incoming) packet above?

The source and destination IP addresses come of course from the packets. 
They have nothing to do with the interfaces - one can route any (sort of) 
packet with any source/destination IP addresses to whatever interface.

Do you skip routers and think of end hosts only, where the 
destination/source IP address is that of the receiving/sending interface?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
