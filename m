From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 15:21:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <021a01c21c4b$47b2f2b0$0489cb8a@etbx180>
References: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Harald Welte" <laforge@gnumonks.org>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > loading a module, doesn't mean using it (lsmod reports it as 'unused'
> > in my tests). So, does it really 'sounds as expected', when you see
> 
> From where do you think that the module usage counter reports how many
> packets/connections are handled (currently? totally?) by the module.
> There is no whatsoever connection!

module usage counter increases when a TARGET needs it (i.e. ipt_REDIRECT).
In this test, no rule was defined, and no target module was loaded.
So I did not expect NAT to process any packet.

> 
> > > > o The cumulative effect should be reconsidered.
> >
> > - I can't explain the last one, but when the table is exhausted
> >   conntrack drops new packets, right? What I noticed is that at that
> >   moment, the cpu load suddenly hit 100%, and the machine did not
> >   recover, unless I killed the load generator
> 
> That is unusual and should be tested further.

I suppose that due to the load, packets are dropped not because of conntrack
but because they simply can't be processed, and thus conntrack misses packets
of existing connections (such as FIN, RST) and can't thus recover due to its 
timeouts.

> 
> > > ? What 'nat table' are  you talking about?  Do you understand how NAT
> > > works and how it interacts with connection tracking?
> >
> > Just to recall my test: I generated an amount of new connections
> > per second passing through a forwarding machine without any iptables
> > module and measured the cpu load/responsiveness and other things...
> > Then while the machine was sustaining this amount of new conn/s, i did
> > 'insmod ip_conntrack [size]', saw the cpu load increasing, and finally
> > just did 'iptables -t nat -L' to load the nat module without any rule,
> > and saw again the cpu load increasing. With 500conn/s, the cpu load went
> > from 10% -> ~50/70% -> 100% (machine unavailable).
> 
> According to your first mail, the machine has 256M RAM and you issued
> 
> insmod ip_conntrack 16384
> 
> That requires 16384*8*~600byte ~= 75MB non-swappable RAM.
> 
> When you issued "iptables -t nat -L", the system tried to reserve plus
> 2x75MB. That's in total pretty near to all your available physical RAM
> and the machine might died in swapping.
> 

exact! 
That's why I looked (but not closely) at swap-in/swap-out in procinfo, 
but didn't notice anything (0 most of the time on 10 sec average). 
But I agree that I was close to the limit, and even over when I tried 32K.
Despite that, nothing so surpising to have so few swaps, since my table
was not full (max 4000 up to 10000 concurrent tuples).

But this raises one additional problem: 
1) the hash index size and the hash total size should be configurable 
separately (get rid of that factor 8, and use a free list for the tuple 
allocation).
2) NAT hash sizes should also be configurable independently from conntrack.
Normally the nat hashes are smaller than conntrack hash, since conntrack
is based on ports, while nat is not.

PS: could anybody redo similar tests so that we can compare the results
    and stop killing the messenger, please? ;o)


> Regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> WWW-Home: http://www.kfki.hu/~kadlec
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
> 
> 
> 
> 
