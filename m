From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel oops when putting the console option in
	/boot/grub/menu.lst
Date: Thu, 10 May 2007 18:44:18 +0200
Message-ID: <46434BE2.5090605@trash.net>
References: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Hung Lin <hlin@nextone.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>
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

Hung Lin wrote:
> Hi,
> 
> I'm using ipset-2.2.9 with kernel 2.6.11.4-21.13 (SuSE 9.3 kernel) and
> iptables-1.3.1-3 (SuSE 9.3 iptables) and everything is fine.  But after
> I added a console option to /boot/grub/menu.lst, the kenrel will hang
> sometimes and show kernel oops message on the monitor.  After research,
> I found it is `iptables -m hashlimit` command to cause this problem.
> Therefore, I did some tests:
> 
> I used a loop to insert and delete hashlimit rules to iptables, here's
> the result:
> 
> 1. with ipset patch and without console option in grub menu, no problem
> 
> 2. withotu ipset patch and with console option in grub menu, no problem
> 
> 3. with ipset patch and with console option in grub menu, kernel crashs
> after hundreds of iterations.
> 
> 
> It looks like console option in the grub menu has something conflict
> with ipset kernel patch.  But I don't understand.
> 
> Please give me your advices.  Thanks in advance.


Please send the oops.
