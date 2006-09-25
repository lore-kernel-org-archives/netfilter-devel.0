From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] fix dreaded "Unknown error 4294967295"
Date: Mon, 25 Sep 2006 22:43:13 +0200
Message-ID: <200609252243.13445.vda.linux@googlemail.com>
References: <200609231343.32610.vda.linux@googlemail.com>
	<4517A2F1.6040307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, webmaster@gnumonks.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4517A2F1.6040307@trash.net>
Content-Disposition: inline
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

Hello Patrick,

On Monday 25 September 2006 11:35, Patrick McHardy wrote:
> Denis Vlasenko wrote:
> > google.com gives 968 hits on 'iptables "Unknown error 4294967295"'.
> > 
> > The reason is that iptables sets errno
> > to error return value of setsockopt(), which is always -1.
> 
> Thats already fixed in the current SVN version, which will be released
> as 1.3.6 soon.

Cool, thank you.

I have some troubles setting up firewall on AMD64 kernel
with 32-bit userspace.

When I pointed KERNEL_DIR= to the build directory
of currently running kernel, i saw -DKERNEL_64_USERSPACE_32
in gcc commands and resulting iptables was utterly useless.
It was throwing "Unknown error 4294967295" on practically anything.

I rebuilt it, pointing KERNEL_DIR= to pristine, unconfigured
2.6.18 source. Now it works most of the time.

However, on some commands it does not:

iptables -t nat -A OUTPUT --match connmark --mark 22 -j RETURN
iptables -t nat -A OUTPUT -j CONNMARK --set-mark 22

give the same error and in dmesg I see:

ip_tables: connmark match: invalid size 24 != 12
ip_tables: CONNMARK target: invalid size 24 != 12
ip_tables: connmark match: invalid size 24 != 12
ip_tables: CONNMARK target: invalid size 24 != 12

Same happens on MARK target.

Help?
--
vda
