From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Thu, 28 May 2009 12:39:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905281204270.26723@blackhole.kfki.hu>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>  <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu> <17923cc80905280300n2efa5bcfqed0661da291300@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Saatvik Agarwal <saatvik.agarwal@stanford.edu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: sachin sanap <sachin.sanap.1gb@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <17923cc80905280300n2efa5bcfqed0661da291300@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 28 May 2009, sachin sanap wrote:

> On Thu, May 28, 2009 at 2:28 PM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> > On Wed, 27 May 2009, Saatvik Agarwal wrote:
> >
> >> For my research project in school, I am trying to establish TCP
> >> connections when both hosts are behind full-cone NATs using TCP's
> >> simultaneous open functionality. Unfortunately, it seems that iptables
> >> does not support TCP simultaneous open. For my test environment, I
> >> simulate a full-cone NAT using iptables. My iptables rule is exactly
> >> as follows:
> >>
> >> iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> >
> > That rule cannot simulate full-cone NAT, because netfilter implements
> > port-restricted cone NAT.
> I agree to most of stuff that you have said but the above statement of
> "port-restricted cone NAT" confuses me.
> If we look at different types of NATs as mentioned here
> www.crfreenet.org/~martin/referaty/stun/naty.pdf , i think the
> netfilter implementation is really a symmetric NAT.
> Iam I missing some thing?

It depends.

With MASQUERADE it's a port-restricted cone NAT.

Using the --random flag with SNAT you can almost create a symmetric NAT 
with netfilter, except that the "requirements" of the symmetric NAT (RFC 
3489) includes mapping to an unique source IP address and port whenever 
the same internal host connects to different external hosts. However 
netfilter creates an unique tuple (mapped src IP, mapped src port, dst IP, 
dst port) not just an unique pair of (mapped src IP, mapped src port).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
