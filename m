From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: [LARTC] dst cache overflow (bridged wan interfaces)
Date: Fri, 12 Jan 2007 02:13:09 +0100 (CET)
Message-ID: <58296.84.123.236.132.1168564389.squirrel@www.arcoscom.com>
References: <41878.84.123.236.132.1168460040.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <41878.84.123.236.132.1168460040.squirrel@www.arcoscom.com>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	lartc@mailman.ds9a.nl
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

The problem appears to be in the routes patch (after 1 day with 1
workstation with amule configured very agresively).

I'm trying now the 2.6.19.2 kernel with the configuration exposed here,
I'll tell you if the problem were (or not) the patch for
dead-gw-detection/multipath-routes from nano-howto. Perhaps this patch is
for specific configuration and need more accurate routes config (don't
know).

As I said: I'll say if I the problem persist in some days.

Thank you very much.

Regards

El Mie, 10 de Enero de 2007, 21:14, ArcosCom Linux User escribió:
> I recompiled yet 2.6.19.1 kernel (using iptables with the same patches
> too).
>
> The configuration for this test is:
>    1) linux box with 2.6.19.1 kernel (SMP machine) with these
> patches/modules:
>       a) l7-filter
>       b) ipp2p
>       c) connlimit
>       d) set
>    2) 4 ethernet interfaces:
>       a) 2 external (eth1 and eth3) interfaces with balanced links (as
> described in nato-howto) bridged as wan0 with static IPs assigned to
> wan0 and wan0:1
>       b) 2 internal ineterfaces (eth0 and eth2) in bridge zlan0 with STP
> enabled and configured.
>
> IPTABLES relevant configuration:
> # iptables -t nat -vn -L POSTROUTING
> Chain POSTROUTING (policy ACCEPT 185 packets, 16649 bytes)
>  pkts bytes target     prot opt in     out     source
> destination
>    26  1529 MASQUERADE  0    --  *      wan0    10.1.1.0/27
> 0.0.0.0/0
>     0     0 MASQUERADE  0    --  *      wan0:1  10.1.1.0/27
> 0.0.0.0/0
>
>
> ROUTES CONFIGURATION:
> # service rt status
> === REGLAS DE ENRUTAMIENTO ===
> 0:      from all lookup local
> 50:     from all lookup main
> 151:    from NET_PUB1 lookup 151
> 152:    from NET_PUB2 lookup 152
> 220:    from all lookup 220
> 32766:  from all lookup main
> 32767:  from all lookup default
> === TABLAS DE RUTAS ===
> === MAIN ===
> NET_PUB1/26 dev wan0  proto kernel  scope link  src IP_PUB1
> NET_PUB2/24 dev wan0  proto kernel  scope link  src IP_PUB2
> 192.168.3.0/24 dev zlan0  proto kernel  scope link  src 192.168.3.247
> 192.168.2.0/24 dev zlan0  proto kernel  scope link  src 192.168.2.247
> 192.168.1.0/24 dev zlan0  proto kernel  scope link  src 192.168.1.247
> 10.1.1.0/24 dev zlan0  proto kernel  scope link  src 10.1.1.6
> 169.254.0.0/16 dev zlan0  scope link
> 239.0.0.0/8 dev zlan0  scope link
> === wan0 TABLA 151 ===
> default via GW_PUB1 dev wan0  proto static  src IP_PUB1
> prohibit default  proto static  metric 1
> === wan0 TABLA 152 ===
> default via GW_PUB2 dev wan0  proto static  src IP_PUB2
> prohibit default  proto static  metric 1
> === TABLA 220 (defecto) ===
> default  proto static
>         nexthop via GW_PUB1  dev wan0 weight 1
>         nexthop via GW_PUB2  dev wan0 weight 1
>
> ROUTING parameters configuration:
> # grep . /proc/sys/net/ipv4/route/*
> /proc/sys/net/ipv4/route/error_burst:5000
> /proc/sys/net/ipv4/route/error_cost:1000
> grep: /proc/sys/net/ipv4/route/flush: Operación no permitida
> /proc/sys/net/ipv4/route/gc_elasticity:8
> /proc/sys/net/ipv4/route/gc_interval:60
> /proc/sys/net/ipv4/route/gc_min_interval:0
> /proc/sys/net/ipv4/route/gc_min_interval_ms:500
> /proc/sys/net/ipv4/route/gc_thresh:32768
> /proc/sys/net/ipv4/route/gc_timeout:300
> /proc/sys/net/ipv4/route/max_delay:10
> /proc/sys/net/ipv4/route/max_size:524288
> /proc/sys/net/ipv4/route/min_adv_mss:256
> /proc/sys/net/ipv4/route/min_delay:2
> /proc/sys/net/ipv4/route/min_pmtu:552
> /proc/sys/net/ipv4/route/mtu_expires:600
> /proc/sys/net/ipv4/route/redirect_load:20
> /proc/sys/net/ipv4/route/redirect_number:9
> /proc/sys/net/ipv4/route/redirect_silence:20480
> /proc/sys/net/ipv4/route/secret_interval:600
>
> When I test it along some weeks with intensive traffic I'll put here more
> info about this test.
>
> If somebody has any idea on how to solve the problem, please, tell us. I'm
> a bit desesperate with this issue.
>
> Regards
>
> _______________________________________________
> LARTC mailing list
> LARTC@mailman.ds9a.nl
> http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc
>
