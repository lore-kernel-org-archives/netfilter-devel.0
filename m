From: Sasikanth babu <sasikanth.v19@gmail.com>
Subject: Re: IPV6: kernel panic in net filter and ipv6 path while doing
 interface up and down continuously with ipv6 traffic
Date: Mon, 23 Dec 2013 23:44:50 +0530
Message-ID: <CAOJFanWSarYPDhn4JastGkCAqoMiqS9cVAYJ_aZ1nd1idy7Q9w@mail.gmail.com>
References: <CAOJFanX-YC7s9LEzifqryboqY98Enz4ZnGahYOLuix3hLpT_8Q@mail.gmail.com>
	<866aa834-3ee6-4e54-9233-ce43db37c326@email.android.com>
	<CAOJFanUS8Zfi2t6PCiip4Gp_xUBRMC8xzbvt1WU9e7Bq-+ybgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Shawn Wilson <ag4ve.us@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62777 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3LWSOv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:14:51 -0500
In-Reply-To: <CAOJFanUS8Zfi2t6PCiip4Gp_xUBRMC8xzbvt1WU9e7Bq-+ybgg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adding to last mail the panics were observed If I remove  V6 IP
address and while packets are still flowing.

On Mon, Dec 23, 2013 at 2:48 PM, Sasikanth babu <sasikanth.v19@gmail.com> wrote:
> Panic 1
>
>    While sending IPv6 user traffic did interface down and up.
>
> Panic 2
>
>    While testing IPv6 ND did interface down and up.
>
> Observed these panics 2/3 times.
>
> On Mon, Dec 23, 2013 at 2:34 PM, Shawn Wilson <ag4ve.us@gmail.com> wrote:
>> How do you replicate it?
>>
>> Sasikanth babu <sasikanth.v19@gmail.com> wrote:
>>>Hi,
>>>
>>>Any suggestions/idea about this panic. is it related IPv6 or netfilter.
>>>
>>>I looked out for the patches and verified the kernel commit messages I
>>>could not find anything related to this panic.
>>>
>>>Any suggestions?
>>>
>>>Thanks in advance
>>>
>>>Kernel : 2.6.34.10
>>>arch:   Mips
>>>
>>>
>>>[ 7078.035218] Oops[#1]:
>>>[ 7078.037492] Cpu 0
>>>[ 7078.039416] $ 0   : 0000000000000000 000000000000000c
>>>a8000000e2f3f000 0000000100000060
>>>[ 7078.047482] $ 4   : 00000000ffffff00 0000000000000000
>>>0000000000000020 0000000000000160
>>>[ 7078.055546] $ 8   : 0000000000000100 000000000000000c
>>>0000000060300000 ffffffff80000000
>>>[ 7078.063611] $12   : 0000000000000018 ffffffff8055d950
>>>ffffffff806c2318 0000000000000000
>>>[ 7078.071677] $16   : a800000195fda500 a80000043fe44600
>>>0000000000000000 0000000000000001
>>>[ 7078.079742] $20   : 0000000000000000 a800000195fda100
>>>0000000000000001 ffffffff81221f70
>>>[ 7078.087807] $24   : 2000000000000000 ffffffff8077fb38
>>>[ 7078.095872] $28   : a8000003bd5bc000 a8000003bd5bf8a0
>>>a8000003bd5bf9d0 ffffffff8077f9a0
>>>[ 7078.103937] Hi    : 0000000000000000
>>>[ 7078.107511] Lo    : 0000000000000420
>>>[ 7078.111095] epc   : ffffffff8077fa28 ip6_pkt_drop+0x110/0x1e0
>>>[ 7078.116841]     Not tainted
>>>[ 7078.119636] ra    : ffffffff8077f9a0 ip6_pkt_drop+0x88/0x1e0
>>>[ 7078.125295] Status: 10108ce3    KX SX UX KERNEL EXL IE
>>>[ 7078.130605] Cause : 00800008
>>>[ 7078.133485] BadVA : 0000000100000068
>>>[ 7078.137060] PrId  : 000d910a (Cavium Octeon II)
>>>[ 7078.141590] Modules linked in: ip_tables iptable_filter
>>>iptable_mangle ip6_tables ip6table_filter ip6table_mangle mloopback
>>>bonding bfpga octeon_pow_ether nfnetlink nfnetlink_queue xt_DSCP
>>>xt_NFQUEUE [last unloaded: scsi_wait_scan]
>>>[ 7078.162303] Process wamgr (pid: 1087, threadinfo=a8000003bd5bc000,
>>>task=a80000043edc5400, tls=000000555d1192b0)
>>>[ 7078.172391] Stack : 0000000000000004 a800000195fda500
>>>a800000195f83000 a800000195fda500
>>>[ 7078.180270]         a80000043fda2900 ffffffff806fda9c
>>>ffffffff81116f18 a800000188cfe010
>>>[ 7078.188335]         0000000000000001 a80000018aa9e414
>>>a80000043fda2940 a8000003bd5bf960
>>>[ 7078.196399]         a800000195f83000 ffffffffc00add20
>>>0020000000000000 a80000018aa9e400
>>>[ 7078.204463]         a800000195fda100 a80000018aa9e400
>>>a800000195fda100 ffffffffc00ae788
>>>[ 7078.212527]         ffffffffc00ae8b8 a8000003bd5bf9d0
>>>a800000195fda100 ffffffffc00a43bc
>>>[ 7078.220592]         0000000000000000 0000000000000000
>>>a80000018aa9e414 0000000000000000
>>>[ 7078.228656]         0000000000000000 0000000000000000
>>>0000000000000000 0000000000000000
>>>[ 7078.236720]         0000000000000000 0000000000000000
>>>0000000000000000 a8000003bd5bf930
>>>[ 7078.244784]         ffffffff803b0c68 00000000ffffff01
>>>a80000018aa9e414 0000000000000020
>>>[ 7078.252848]         ...
>>>[ 7078.255502] Call Trace:
>>>[ 7078.257951] [<ffffffff8077fa28>] ip6_pkt_drop+0x110/0x1e0
>>>[ 7078.263353] [<ffffffff806fda9c>] nf_reinject+0x9c/0x180
>>>[ 7078.268585] [<ffffffffc00add20>] nfqnl_recv_verdict+0x2a8/0x368
>>>[nfnetlink_queue]
>>>[ 7078.276074] [<ffffffffc00a43bc>] nfnetlink_rcv_msg+0x21c/0x320
>>>[nfnetlink]
>>>[ 7078.282950]
>>>[ 7078.284440]
>>>[ 7078.284442] Code: 000528f8  7ca2120a  0083182d <dc630008> 00c3302d
>>>00c2302d  dcc20000  64420001  081dfe53
>>>[ 7078.295797] Disabling lock debugging due to kernel taint
>>>[ 7078.301148] Kernel panic - not syncing: Fatal exception in interrupt
>>>[ 7088.034346] INFO: RCU detected CPU 0 stall (t=2500 jiffies)
>>>[ 7118.034349] INFO: RCU detected CPU 0 stall (t=10000 jiffies)
>>>[ 7148.034347] INFO: RCU detected CPU 0 stall (t=17500 jiffies)
>>>[ 7178.034346] INFO: RCU detected CPU 0 stall (t=25000 jiffies)
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe netfilter" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
