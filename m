From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 13:33:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu>
References: <008201c21a96$88eb6520$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <008201c21a96$88eb6520$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 23 Jun 2002, Jean-Michel Hemstedt wrote:

> > > I'm doing some tcp benches on a netfilter enabled box and noticed
> > > huge and surprising perf decrease when loading iptable_nat module.
> >
> > Sounds as expected.
>
> loading a module, doesn't mean using it (lsmod reports it as 'unused'
> in my tests). So, does it really 'sounds as expected', when you see

>From where do you think that the module usage counter reports how many
packets/connections are handled (currently? totally?) by the module.
There is no whatsoever connection!

> > > o The cumulative effect should be reconsidered.
>
> - I can't explain the last one, but when the table is exhausted
>   conntrack drops new packets, right? What I noticed is that at that
>   moment, the cpu load suddenly hit 100%, and the machine did not
>   recover, unless I killed the load generator

That is unusual and should be tested further.

> > ? What 'nat table' are  you talking about?  Do you understand how NAT
> > works and how it interacts with connection tracking?
>
> Just to recall my test: I generated an amount of new connections
> per second passing through a forwarding machine without any iptables
> module and measured the cpu load/responsiveness and other things...
> Then while the machine was sustaining this amount of new conn/s, i did
> 'insmod ip_conntrack [size]', saw the cpu load increasing, and finally
> just did 'iptables -t nat -L' to load the nat module without any rule,
> and saw again the cpu load increasing. With 500conn/s, the cpu load went
> from 10% -> ~50/70% -> 100% (machine unavailable).

According to your first mail, the machine has 256M RAM and you issued

insmod ip_conntrack 16384

That requires 16384*8*~600byte ~= 75MB non-swappable RAM.

When you issued "iptables -t nat -L", the system tried to reserve plus
2x75MB. That's in total pretty near to all your available physical RAM
and the machine might died in swapping.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
