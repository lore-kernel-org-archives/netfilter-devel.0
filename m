From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Fri, 10 Sep 2004 16:06:17 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040910140617.GA4314@soohrt.org>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
	<20040907084151.GG16651@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040907084151.GG16651@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Harald Welte wrote:
> On Mon, Sep 06, 2004 at 10:56:53PM +0200, Karsten Desler wrote:
> > I'm using two Opteron 244 on a Tyan S2882 mainboard with 2gb of RAM
> > and a vanilla 64bit 2.6.9-rc1-bk11 kernel.
> 
> - how fast are your pci busses?  (I had PCI-X 133)

PCI-X 133 here too.

> - how fast is your memory (I had DDR400) _VERY_ important!

The memory itself is DDR400, but opterons 244 only support DDR333.
Opterons >= 246 (which support DDR400) are virtually impossible to get
on short notice on the german market.

> > - I've increased ip_conntrack_htable_size to 65536.
> 
> maybe still too little,

Ok, I'm going to test with increased values tomorrow.
Is there a point in lowering the factor in the ip_conntrack_max
calculation to reduce the length of the linked list per bucket?

> > eth0 is:
> > 0000:01:01.0 Ethernet controller: Intel Corp. 82545EM Gigabit Ethernet Controller (Fiber) (rev 01)
> > eth1 is:
> > 0000:01:03.0 Ethernet controller: Intel Corp. 82546GB Gigabit Ethernet Controller (rev 03)
> 
> This seems like both e1000 seem to be attached to the same PCI bus,
> which is probably also not good for highest performance

True, they are in the same riser card and the fibre card only supports
33MHz/64bit PCI while the dual-copper adapter supports PCIX-133.

> > /proc/interrupts:
> >            CPU0       CPU1
> >   0:   67093304          0    IO-APIC-edge  timer
> >   8:          4          0    IO-APIC-edge  rtc
> >   9:          0          0   IO-APIC-level  acpi
> > 169:     117226          0   IO-APIC-level  libata
> > 201:  213918484          0   IO-APIC-level  eth0
> > 209:         11  211891491   IO-APIC-level  eth1
> 
> are you sure you have NAPI enabled?  You shouldn't get that much
> interrupts if using NAPI and going into saturation

Pretty sure, yes. I'm getting around 7000 interrupts per second, which
fits perfectly in the 3000 interrupts/s/card and 1000 timer interrupts/s
picture.

> > net/ipv4/conf/all/rp_filter=1
> 
> never ever enable rp_filter, that makes a huge difference.  rp_filter is
> not even recommended as default, and probably Debian is the only
> distribution doing that mistake (read netdev archives on this).

Ok, I've disabled rp_filter and added rp_filter-like iptables
rules, doesn't make much (any?) difference though.
before:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0      0 1649708 111172 179052   0    0     0    10 6997    60  0 21 79  0
 0  0      0 1649708 111172 179052   0    0     0     2 7032    61  0 21 79  0
 0  0      0 1649700 111172 179052   0    0     0     0 7019   149  1 21 78  0
 0  0      0 1649708 111172 179052   0    0     0   122 7052    72  0 21 79  0
  

after:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0      0 1649836 111176 179048   0    0     0    10 7181    64  0 21 79  0
 0  0      0 1649620 111176 179048   0    0     0    16 7135   171  1 21 78  0
 0  0      0 1649620 111180 179044   0    0     0   122 7050    71  0 21 79  0
 0  0      0 1649644 111180 179044   0    0     0    36 6981   102  0 21 79  0

> > wc -l /proc/net/ip_conntrack
> > 54243 /proc/net/ip_conntrack
> 
> Ok.  I was testing single-flow UDP performance, not 50k different
> flows...

And could that be the cause for such vastly different results?
If desired, I guess I could give oprofile a try.

Thanks,
 Karsten
