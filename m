From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: dst cache overflow
Date: Wed, 10 Jan 2007 12:33:09 +0100 (CET)
Message-ID: <59046.195.55.244.106.1168428789.squirrel@www.arcoscom.com>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
	<55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
	<45A492AE.2030909@trash.net>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <45A492AE.2030909@trash.net>
To: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

The configuration is:
   1) linux box with 2.6.19.1 kernel with these patches/modules:
      a) l7-filter
      b) multipath patch (from nano-howto)
      c) IMQ
      d) ipp2p
      e) connlimit
   2) 4 ethernet interfaces:
      a) 2 external (eth1 and eth3) interfaces with balanced links (as
described in nato-howto).
      b) 2 internal ineterfaces (eth0 and eth2) in bridge zlan0 with STP
enabled and configured.
   3) For tests I load manually ALL conntrack/nat kernel modules.

My first attempt (to allow UPnP daemon to handle only 1 external iface)
where put eth1 and eth3 in a bridge without STP enabled and the NAT were
done only with -j MASQUERADE and appeared to work fine, but when I run
some amule clients along the network, the problem appear in one day (after
some weeks working without peers to peers software).

Then I broke the wan bridge and put each static external IP into their
iface, and the problem appears too in two days instead 1 day.

My next step were use SNAT instead MASQUERADE and the problem appears 3
days after the change.

Always I had the multipath enableded along these described steps.

A production linux box with 2.6.17.14 kernel and the same patches/modules
and only 1 wan iface and 1 lan iface and with connlimit match enabled by
host is working fine with 100 more p2p traffic than the test machine (the
linux box that has de dst cache overflow problem).

If you need more info about this to help me in solve this problem, please,
say me, I'll get all you need and put here.

Thanks

El Mie, 10 de Enero de 2007, 8:15, Patrick McHardy escribió:
> ArcosCom Linux User wrote:
>> The log says:
>>
>> Dec 30 00:52:27 cura kernel: dst cache overflow
>> Dec 30 00:52:27 cura kernel: MASQUERADE: No route: Rusty's brain broke!
>> Dec 30 00:52:27 cura kernel: dst cache overflow
>> Dec 30 00:52:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
>> Dec 30 00:52:28 cura kernel: zlan0: topology change detected,
>> propagating
>> Dec 30 00:52:28 cura kernel: dst cache overflow
>> Dec 30 00:52:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
>> Dec 30 00:52:30 cura kernel: zlan0: topology change detected,
>> propagating
>> Dec 30 00:52:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
>> Dec 30 00:52:32 cura kernel: zlan0: topology change detected,
>> propagating
>> Dec 30 00:52:32 cura kernel: printk: 15 messages suppressed.
>> Dec 30 00:52:32 cura kernel: dst cache overflow
>> Dec 30 00:52:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
>> Dec 30 00:52:34 cura kernel: zlan0: topology change detected,
>> propagating
>> Dec 30 00:52:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
>> Dec 30 00:52:36 cura kernel: zlan0: topology change detected,
>> propagating
>> Dec 30 00:52:37 cura kernel: printk: 40 messages suppressed.
>> Dec 30 00:52:37 cura kernel: dst cache overflow
>>
>> zlan0 is a bridge (with STP configured) between some LANs.
>>
>> Thanks
>>
>> P.D.: I'm a bit desesperated with this error, I changed "MASQUERADE"
>> with
>> "SNAT" with no sense. Some hours after router is booted up, the network
>> appears to be UP but all ifaces haven't responses.
>
>
> The MASQUERADE message is just an effect of the problem. Please describe
> your setup in more detail (what kind of devices, how are they connected,
> ebtables/iptables rules, routing, ...).
>
>
