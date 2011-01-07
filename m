From: Marek Kierdelewicz <marek@piasta.pl>
Subject: Re: new netfilter target - DNETMAP
Date: Fri, 7 Jan 2011 22:23:49 +0100
Message-ID: <20110107222349.6503ed26@kuguar>
References: <20110107000259.775ba310@kuguar>
	<alpine.LNX.2.01.1101070008590.19521@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1101070008590.19521@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>Hi,

Hi,

>Have you considered updating the NETMAP target inside the linux
>kernel instead?

Nope, I haven't thought about it. It's doable. Classic NETMAP
functionality could be available through some rule option.

>Your idea looks interesting in that I could envision it superseding
>DNAT, SNAT and NETMAP altogether.

Thanks :-).

>>Polite request to Jan Engelhardt for inclusion of the target into
>>xtables-addons.
>It would be nice if you could
> * resolve the inconsistencies in indentation. Specifically, use tabs
>...
> * wrap lines at 80 cols in xt_DNETMAP.man 

Will do.

>The manpage mentions "If host 192.168.0.10 generates some traffic, it 
>gets bound to first free IP in subnet - 20.0.0.0.". However,
>20.0.0.0 can be a network address and thus lead to problems.

Usage of network and broadcast addresses for NAT shouldn't pose
any kind of problems. I tested such setups in my networks. If you use
classic NETMAP to map wider address space to shorter one, you can also
have flows NATed to network and broadcast address of subnet specified
as a parameter of the NETMAP rule.

>Is there a way for the user to specify that the range to use
>should be 20.0.0.1-20.255.255.254 rather than 20.0.0.0-20.255.255.255?

Not yet, but module option could do a trick as long as it's really
necessary.

Best regards,
Marek Kierdelewicz
