From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Thu, 28 May 2009 15:30:29 +0530
Message-ID: <17923cc80905280300n2efa5bcfqed0661da291300@mail.gmail.com>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>
	 <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Saatvik Agarwal <saatvik.agarwal@stanford.edu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 28, 2009 at 2:28 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Wed, 27 May 2009, Saatvik Agarwal wrote:
>
>> For my research project in school, I am trying to establish TCP
>> connections when both hosts are behind full-cone NATs using TCP's
>> simultaneous open functionality. Unfortunately, it seems that iptables
>> does not support TCP simultaneous open. For my test environment, I
>> simulate a full-cone NAT using iptables. My iptables rule is exactly
>> as follows:
>>
>> iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
>
> That rule cannot simulate full-cone NAT, because netfilter implements
> port-restricted cone NAT.
I agree to most of stuff that you have said but the above statement of
"port-restricted cone NAT" confuses me.
If we look at different types of NATs as mentioned here
www.crfreenet.org/~martin/referaty/stun/naty.pdf , i think the
netfilter implementation is really a symmetric NAT.
Iam I missing some thing?

>
>> According to the BEHAVE requirements outlined in IETF RFC 5382, TCP
>> simultaneous open must be supported by "well behaved NATs". So is
>> there a mistake in my rules or does iptables not support simultaneous
>> open?
>
> The connection tracking subsystem does not support TCP simultaneous open.
>
> As far as I'm concerned, I do not care whatever RFC is created in trying
> to push NAT over its limits - that is just a totally wrong track. NAT was
> invented solely to slow down the depletion of the IPv4 address space in
> the hope to give more time introducing and *deploying* IPv6 world-wide.
> And everyone was fully aware that NAT breaks one of the key concempts of
> IP, the end-to-end connectivity. These "NAT behavioral requirements" RFCs
> are the results of that breakage (and written exclusively from the point
> of view of the application designers).
>
> It is no point trying to *put back* end-to-end connectivity on top of NAT
> when the clear and straight solution is to go to IPv6.
>
> The end-to-end connectivity is the very reason why I refuse the idea to
> implement NAT for IPv6 in netfilter. The damage what IPv4 NAT produced
> hasn't taught us not to repeat the same mistake again, willingly?
>
> Best regads,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
