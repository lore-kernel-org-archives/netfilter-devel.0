From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: DoS on kernel 2.4.27+ -j LOG
Date: Fri, 26 Nov 2004 09:58:46 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411260957490.9269@filer.marasystems.com>
References: <6428830866.20041126030601@mail.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Crazy AMD K7 <snort2004@mail.ru>
In-Reply-To: <6428830866.20041126030601@mail.ru>
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

On Fri, 26 Nov 2004, Crazy AMD K7 wrote:

> Has any one know about the bug in 2.4.27 kernel?
> When you use logging in iptables (-j LOG) and a certain bad packet
> come (with illegal flags set) then a DoS occurs.(kernel panic)
>
> Unable to handle kernel paging request ar virtual address 5d5f2739
> printing eip:
> c022dcdc
> *pde=00000000
> Oops: 0000
> CPU: 0
> EIP: 0010:[<c022dcdc>] Not tained
> EFLAGS: 00010246
> then
> eax: .... ebx:.....
> esi, edi, ebp esp
> ds es ss
> Process snort (pid: 687, stackpage=deae3000)
> Stack: deae38a8 c02edb78 00000000 c01ebbc3 00000003 deae38e8 00000000 dfa0b004
> c01f7500 df596078 dfa0b004 00000003 c01f7500 and so on...
>
> Call Trace: [<c01ebbc3>][<c01f7500>] and so on
> Code: 66 83 79 10 08 75 1d a1 2c 33 28 c0 85 c0 74 14 8b 0d 20 33
> <0>Kernel panic: Aiee, killing interrrupt handler!
> In interrupt handler - not syncing

Can you please decode this using ksymoops.

Regards
Henrik
