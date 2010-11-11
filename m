From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 18:25:11 +0100
Message-ID: <20101111172511.GB20871@fi.muni.cz>
References: <20101111150055.GI15421@fi.muni.cz> <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:60617 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0KKRZR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:25:17 -0500
Content-Disposition: inline
In-Reply-To: <4CDC1263.8070206@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
: Am 11.11.2010 16:35, schrieb Eric Dumazet:
: > Please provide 
: > 
: > cat /proc/meminfo

# cat /proc/meminfo 
MemTotal:        2060716 kB
MemFree:          123516 kB
Buffers:          409288 kB
Cached:           943404 kB
SwapCached:          240 kB
Active:          1020036 kB
Inactive:         541816 kB
Active(anon):     121664 kB
Inactive(anon):    92764 kB
Active(file):     898372 kB
Inactive(file):   449052 kB
Unevictable:       18432 kB
Mlocked:           18432 kB
SwapTotal:       1959804 kB
SwapFree:        1957884 kB
Dirty:                96 kB
Writeback:             0 kB
AnonPages:        227276 kB
Mapped:            76724 kB
Shmem:                92 kB
Slab:             268912 kB
SReclaimable:     116940 kB
SUnreclaim:       151972 kB
KernelStack:        1984 kB
PageTables:        10312 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2990160 kB
Committed_AS:     398204 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       33696 kB
VmallocChunk:   34358635704 kB
DirectMap4k:        4032 kB
DirectMap2M:     2093056 kB

: > Also please apply this patch :
: > 
: > http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=6b1686a71e3158d3c5f125260effce171cc7852b

	I will try it tomorrow.

: This problem is usually caused by manipulating the ruleset from multiple
: iptables instances concurrently.

	There probably can be some other iptables commands running
occasionally (automatic blacklisting of some IP addresses, enabling
traffic to authenticated laptops, etc.), but not in the chains I am
trying to modify with my firewall initscript. Can this also be a problem?

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
