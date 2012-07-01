From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 01 Jul 2012 14:17:14 +0100
Message-ID: <4FF04DDA.3020609@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu> <4FF04647.7060807@googlemail.com> <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> Yes. You argue the meaning of a keyword. The meaning is well documented in 
> the manpage, but it's totally counter-intuitive for you. Changing the 
> meaning might break working firewalls. Therefore the meaning won't be 
> changed.
>   
This isn't simply a question of "meaning" - it is an issue caused by the 
fact that you have introduced something which, it seems, wasn't properly 
checked initially for whatever reason and that is causing a great deal 
of inconsistency and inconvenience for people, like myself, who use 
ipset on a daily basis.

When I match an incoming packet destined to an IP address for example, I 
have to use, quite rightly, a "dst" designation, but when I match 
against the interface to which this same IP address belongs to, 
according to your man page, I have to use "src" instead - all this, 
simply because you didn't check this properly when hash:net,iface was 
first released and you can't be bothered, for one reason or another, to 
change it simply because "this has been out for a long time"?

Do you think that all the network admins out there will have to remember 
to use "dst" when matching on destination IP addresses, port numbers 
etc, but use exactly the opposite designation - "src" - when matching on 
the same destination interface that same IP address belongs to? Do you 
not see how inconvenient and downright misleading this is? If you can't, 
you are beyond hope, I am afraid.

Right, I am going to include Patrick in this as this whole saga is 
becoming something of a monologue and I need a bit of clarity on this.

