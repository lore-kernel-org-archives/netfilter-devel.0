From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Kernel oops when putting the console option in
	/boot/grub/menu.lst
Date: Tue, 15 May 2007 11:58:19 +0100
Message-ID: <4649924B.7020301@ufomechanic.net>
References: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

* Hung Lin wrote, On 10/05/07 16:41:
> Hi,
> 
> I'm using ipset-2.2.9 with kernel 2.6.11.4-21.13 (SuSE 9.3 kernel) and
> iptables-1.3.1-3 (SuSE 9.3 iptables) and everything is fine.  But after
> I added a console option to /boot/grub/menu.lst, the kenrel will hang
> sometimes and show kernel oops message on the monitor.  After research,
> I found it is `iptables -m hashlimit` command to cause this problem.
> Therefore, I did some tests:


Try running:
dmesg -n 1

in rc.local or something and then see if you get the oops?

I would guess that a module is doing some printk that are going to the
serial console, which can be slow, very slow. This could well enforce an
otherwise unreachable race condition.

dmesg-n 1 will stop most or all printk from going to the console.

It would be good to track the prink behind it and stop it as it will
still be slowing down the system anyway when it logs a lot to the kernel
ring buffer.

Sam
