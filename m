From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT in kernel >= 2.6.15 broken???
Date: Thu, 26 Jan 2006 12:19:09 +0100
Message-ID: <43D8B02D.9010008@trash.net>
References: <43D74B7D.000002.25194@pantene.yandex.ru>
	<43D74D68.5090808@trash.net>
	<43D75B4A.000005.27248@mfront8.yandex.ru>
	<43D7617C.20102@trash.net> <43D79774.000008.00501@tide.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dkiba@yandex.ru
In-Reply-To: <43D79774.000008.00501@tide.yandex.ru>
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

KdF wrote:
>>KdF wrote:
>>
>>>>>Packets get forwarded as usual without any attempt to be redirected.
> 
> 
>>My guess is that its related to invalid hardware checksums.
>>Please check if you have hw checksumming enabled on the underlying
>>eth device, if so load the ipt_LOG module and execute
>>"echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid"
> 
> 
> I've also tried to build kernel with network debug activated, and here is some output:
> 
> Jan 21 22:45:01 ac kernel: nf_hook: Verdict = QUEUE.
> Jan 21 22:45:07 ac last message repeated 34 times
> Jan 21 22:45:07 ac kernel: ppp21: hw csum failure.
> Jan 21 22:45:07 ac kernel:  [<c03b16f1>] __skb_checksum_complete+0x73/0x79
> Jan 21 22:45:07 ac kernel:  [<c0414b41>] icmp_error+0x12e/0x1b9
> Jan 21 22:45:07 ac kernel:  [<c03cec66>] nfqnl_enqueue_packet+0x1c/0x191
> [...]
>
> After i have activated 
> "echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid "
> there appeared some log records:
> 
> Jan 25 17:11:48 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.204.11 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16778 DF PROTO=TCP SPT=1155 DPT=80 SEQ=1884322362 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
> 
> Is this problem in pppd, pppoe or in underlying interface, and how can i track it? Maybe queue overflow problem that i have described in another post today also relates to this?

Either your network device is generating invalid hardware checksums
(which driver are you using?) or the ppp code doesn't adjust the
checksum when modifying the packet. I'm not sure which it is, we
had a couple of reports of invalid checksums with ppp, so it might
be a bug. The queue overflow is not related, Harald is working on
this, see netfilter bugzilla #404.
