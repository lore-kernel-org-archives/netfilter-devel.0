From: Patrick McHardy <kaber@trash.net>
Subject: Re: Why does ipv6 enabled interfere with ipv4 SNAT?
Date: Tue, 25 Mar 2008 16:53:19 +0100
Message-ID: <47E91FEF.9080705@trash.net>
References: <20080325012807.GA15637@transpect.com> <alpine.LNX.1.10.0803250254100.9368@fbirervta.pbzchgretzou.qr> <20080325024424.GA16089@transpect.com> <Pine.LNX.4.64.0803251156560.1535@blackhole.kfki.hu> <20080325142553.GA8783@transpect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Whit Blauvelt <whit@transpect.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20080325142553.GA8783@transpect.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Whit Blauvelt wrote:
>
> Josef, the set of iptables modules is precisely the same whether or not ipv6
> is enabled on the system (yes, I've looked). The only difference is whether
> the ipv6 module is loaded. Blocking the ipv6 module from loading at boot
> both prevents (of course) the /proc/sys/net/ipv6 space from being populated.
> It also fully restores SNAT functionality.
> 
> There are no error messages from "iptables -t nat" commands. The nat rules
> show up precisely the same in the resulting tables - they just don't count
> any packets traversing them if ipv6 is also enabled. I haven't done packet
> inspection to see what's happening, but the problem remains:
> 
> With _everything else_ unchanged, simply letting the ipv6 module load at
> boot results in:
> 
> 1) eth4 and eth5 not showing up as they should for ipv6 in
>    /proc/sys/net/ipv6/conf
> 
> and (whether related or a separate bug)
> 
> 2) ipv4 Netfilter SNAT (in POSTROUTING in this case) becoming a black hole
> 
> Boxes behind the firewall can still ping the firewall. The firewall can
> still ping the world. But just with the ipv6 module loaded, the boxes behind
> the firewall cannot ping the world. Clearly ipv6 is not properly
> provisioning its space. But why should ipv6's failing have any effect at all
> on ipv4 functionality? 
> 
> For me, not loading the ipv6 module is a totally fine workaround. It's
> useless cruft in my context anyway. But even though my problem is fixed for
> now, it will be a problem for other people (maybe only those with > 4
> ethernet devices?) when the ipv6 transition finally happens. I remember in
> the early 90s when we were expecting it by about 1998.
> 
> So in the spirit of open source development, I'm looking for for someone
> with better knowledge of the underlying theory to help identify where the
> bug here is. Then the responsible developers can have a chance to fix it
> before a lot of other sysadmins also end up wasting many hours because of
> the non-obviousness of having to look at ipv6 stuff to find why ipv4 SNAT
> becomes a black hole.

Please post the list of modules loaded and the output of
/proc/net/nf_conntrack.
