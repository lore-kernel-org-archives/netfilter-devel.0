From: Finite <wiretapped@gmail.com>
Subject: reproducible panic on 2.6.8.1
Date: Thu, 30 Sep 2004 01:15:06 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <bb51a00204093001151728a13@mail.gmail.com>
Reply-To: Finite <wiretapped@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Greetings.

First let me say thank-you for netfilter; I have lost count of the
number of firewalls I've built with it. Excellent software!

Now onto the problem...
I just built linux 2.6.8.1 and am now having a very reproducible
kernel panic. After running my firewall script which should enable
simple masquerading from one interface to another, the machine will
panic as soon as it receives a packet which would be REJECTed. For
instance, under my current configuration, ICMP packets sent to the
router's IP from a machine on the LAN match the default REJECT policy,
and will trigger the panic every time. Also, under this kernel, the
masquerading doesn't work; packets are forwarded out to the net, but
the replies never make it back out to the LAN (ie maybe connection
tracking isn't working?). Even stranger, masquerading *did* work
momentarily when I first tried it (before the first panic) but hasn't
worked at all (under this kernel) since then. And if I flush the
tables, nothing I do will make it panic, but when I reload the rules
it will panic as soon as it tries to REJECT something.

Everything seems to work perfectly fine under my other kernel
(debian's "2.4.18-bf24").

I don't know how to get the full text of the kernel panic (how do I do
that btw?), but I copied down the end of it:
Code: 0f 0b 5f 5b 00 80 7f 44 c0 83 c4 14 5b c3 90 8d b4 26 00 00 00
Kernel panic: fatal exception in interrupt
In interrupt handler - not syncing

Thanks for any help!
