From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 14 Jun 2005 17:27:48 +0200
Message-ID: <42AEF774.8060300@tac.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42A6E685.3060408@eurodev.net>
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

Hello,

> Instead I would say it's too old. It isn't misleading for a kernel
> 2.4.22 but it's simply too old to apply against a 2.4.31 ;).

I'm not yet done with testing, however something is not quite right now:

CPU: 2
EIP: 0010:[<00000000>] Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010202
eax: 00000000 ebx: c287df30 ecx: f8aa1ef4 edx: c287c001
esi: 00000000 edi: f7b92a34 ebp: f7b92980 esp: c287deac
ds: 0018 es: 0018 ss: 0018
Process swapper (pid:0, stackpage=c287d000)
Stack: c02a8f74 f8aa1e80 c287df30 f7b92a34 c01de099 f4a4d920 c287df30 00000040
       f7b92980 f7b92800 00000000 00000001 00000001 f7b92800 f7b92a18 c01ddee9
       f7b92980 f7b928c4 f7b92800 00000002 c0417b20 2471321d 00000000 c02ad245
Call trace:  [<c02a8f74>] [<f8aa1e80>] [<c01de099>] [<c01ddee9>] [<c02ad245>]
[<c011f7ad>] [<c0108e00>] [<c0105330>] [<c0105330>] [<c0105330>] [<c0105330>]
[<c010535c>] [<c01053c2>] [<c011a859>]
Code: Bad EIP value.


>>EIP; 00000000 Before first symbol

>>ebx; c287df30 <_end+239de98/385bafc8>
>>ecx; f8aa1ef4 <[ip_conntrack]ip_conntrack_untracked+74/144>
>>edx; c287c001 <_end+239bf69/385bafc8>
>>edi; f7b92a34 <_end+376b299c/385bafc8>
>>ebp; f7b92980 <_end+376b28e8/385bafc8>
>>esp; c287deac <_end+239de14/385bafc8>

Trace; c02a8f74 <__kfree_skb+9c/16c>
Trace; f8aa1e80 <[ip_conntrack]ip_conntrack_untracked+0/144>
Trace; c01de099 <e1000_clean_tx_irq+fd/3b4>
Trace; c01ddee9 <e1000_clean+2d/e0>
Trace; c02ad245 <net_rx_action+c1/180>
Trace; c011f7ad <do_softirq+7d/dc>
Trace; c0108e00 <do_IRQ+190/1a0>
Trace; c0105330 <default_idle+0/34>
Trace; c0105330 <default_idle+0/34>
Trace; c0105330 <default_idle+0/34>
Trace; c0105330 <default_idle+0/34>
Trace; c010535c <default_idle+2c/34>
Trace; c01053c2 <cpu_idle+3e/54>
Trace; c011a859 <printk+181/1c0>

<0> Kernel panic: Aiee, killing interrupt handler!

65 warnings issued.  Results may not be reliable.

If you have any idea let me know, I for once will try to reproduce a clean
kernel patch and retest again. This oops is triggable by reconfiguring the
packet filter while having a moderate throughput through the UNTRACKED chain.
Having the iptstate gui running increases the trigger rate.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
