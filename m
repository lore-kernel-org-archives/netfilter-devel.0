From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 18:58:15 +0100
Message-ID: <1289498295.17691.1589.camel@edumazet-laptop>
References: <20101111150055.GI15421@fi.muni.cz>
	 <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net>
	 <20101111172511.GB20871@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49286 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab0KKR6U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:58:20 -0500
Received: by wyb28 with SMTP id 28so960292wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2010 09:58:19 -0800 (PST)
In-Reply-To: <20101111172511.GB20871@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 11 novembre 2010 =C3=A0 18:25 +0100, Jan Kasprzak a =C3=A9crit=
 :
> Patrick McHardy wrote:
> : Am 11.11.2010 16:35, schrieb Eric Dumazet:
> : > Please provide=20
> : >=20
> : > cat /proc/meminfo
>=20
> # cat /proc/meminfo=20
> MemTotal:        2060716 kB
> MemFree:          123516 kB
> Buffers:          409288 kB
> Cached:           943404 kB
> SwapCached:          240 kB
> Active:          1020036 kB
> Inactive:         541816 kB
> Active(anon):     121664 kB
> Inactive(anon):    92764 kB
> Active(file):     898372 kB
> Inactive(file):   449052 kB
> Unevictable:       18432 kB
> Mlocked:           18432 kB
> SwapTotal:       1959804 kB
> SwapFree:        1957884 kB
> Dirty:                96 kB
> Writeback:             0 kB
> AnonPages:        227276 kB
> Mapped:            76724 kB
> Shmem:                92 kB
> Slab:             268912 kB
> SReclaimable:     116940 kB
> SUnreclaim:       151972 kB
> KernelStack:        1984 kB
> PageTables:        10312 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     2990160 kB
> Committed_AS:     398204 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       33696 kB
> VmallocChunk:   34358635704 kB
> DirectMap4k:        4032 kB
> DirectMap2M:     2093056 kB
>=20
> : > Also please apply this patch :
> : >=20
> : > http://git2.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3D=
commitdiff;h=3D6b1686a71e3158d3c5f125260effce171cc7852b
>=20
> 	I will try it tomorrow.
>=20

Sorry, you dont need it, since you run a 64bit kernel.


> : This problem is usually caused by manipulating the ruleset from mul=
tiple
> : iptables instances concurrently.
>=20
> 	There probably can be some other iptables commands running
> occasionally (automatic blacklisting of some IP addresses, enabling
> traffic to authenticated laptops, etc.), but not in the chains I am
> trying to modify with my firewall initscript. Can this also be a prob=
lem?
>=20

Yes it is a problem. iptables manipulates the whole table, not a
subtree.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
