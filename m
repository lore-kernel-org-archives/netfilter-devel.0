From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: a few questions if you don't mind
Date: Thu, 24 Apr 2003 14:02:19 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424043357.702F82C0D3@lists.samba.org>
References: <200304231517.52954.Joao.Carvalho@foxlink.org>
Cc: netfilter-devel@lists.netfilter.org, buytenh@gnu.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joao Carvalho <Joao.Carvalho@foxlink.org>
In-reply-to: Your message of "Wed, 23 Apr 2003 15:17:52 +0100."
             <200304231517.52954.Joao.Carvalho@foxlink.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <200304231517.52954.Joao.Carvalho@foxlink.org> you write:
> I am quite new to kernel profiling and searching for bottlenecks so i really 
> need help on this one, because it is quite weard.
> First the kernel is 2.4.21rc1 with the bridge-nf and ebtables patch. 
> i have 2 ethernet cards "intel pro 100 S" 
> the processor is an AMD Atlon XP 2000+
> with 256MB of Ram.

Hi Joao!

> I want it to act as an bridging firewall and it does that the only prob is 
> when i start getting lots of simultaneos connections i start getting a very 
> poor performance , one of my tests was with about 5000 con. i could only 
> obtain an ftp connection of 50KB if i remove the bridge i get 5MB.
> the more connections i get the less goes through , now for the weard stuff
> the load of the processor is 0.00 .

Yes, the load will not reflect packet load.  Have you tried without
ebtables ie. just using the box as a router?  This will tell us
whether it's the bridging code, or the connection tracking code whihc
is the bottleneck.

>  eth0      Link encap:Ethernet  HWaddr 00:02:B3:63:AB:3B
>           UP BROADCAST PROMISC MULTICAST  MTU:1500  Metric:1
>           RX packets:47043 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:43372 errors:0 dropped:0 overruns:2 carrier:0
>           collisions:2691 txqueuelen:50
>           RX bytes:8734584 (8.3 Mb)  TX bytes:30477653 (29.0 Mb)
>           Interrupt:11 Base address:0xc000 Memory:ec051000-ec051038
> 
> eth1      Link encap:Ethernet  HWaddr 00:02:B3:A3:37:55
>           UP BROADCAST PROMISC MULTICAST  MTU:1500  Metric:1
>           RX packets:45567 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:45277 errors:741 dropped:0 overruns:0 carrier:741
>           collisions:1799 txqueuelen:100
>           RX bytes:29927115 (28.5 Mb)  TX bytes:9173841 (8.7 Mb)
>           Interrupt:11 Base address:0xc400 Memory:ec050000-ec050038

Hmm, these collisions and errors look very bad to me.

>  1048379 default_idle                             21841.2292
>  14094 handle_IRQ_event                         125.8393
>   1263 __rdtsc_delay                             39.4688
>    640 serial_in                                 13.3333
>   1677 do_softirq                                10.4812
>      7 ide_outb                                   0.4375
>     33 cpu_idle                                   0.3438
>     21 generic_unplug_device                      0.3281
>      3 ide_inb                                    0.1875
>     67 ide_do_request                             0.1675
>      8 system_call                                0.1429

Yes, I think the collisions and errors are your problem, looking at
this.  I don't know why 8(

Sorry I can't be of more help,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
