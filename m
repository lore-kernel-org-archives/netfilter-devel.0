From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix dreaded "Unknown error 4294967295"
Date: Tue, 26 Sep 2006 12:50:00 +0200
Message-ID: <451905D8.5@trash.net>
References: <200609231343.32610.vda.linux@googlemail.com>
	<4517A2F1.6040307@trash.net>
	<200609252243.13445.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
In-Reply-To: <200609252243.13445.vda.linux@googlemail.com>
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

[removed CC: webmaster@gnumonks.org]

Denis Vlasenko wrote:
> I have some troubles setting up firewall on AMD64 kernel
> with 32-bit userspace.
> 
> When I pointed KERNEL_DIR= to the build directory
> of currently running kernel, i saw -DKERNEL_64_USERSPACE_32
> in gcc commands and resulting iptables was utterly useless.
> It was throwing "Unknown error 4294967295" on practically anything.
> 
> I rebuilt it, pointing KERNEL_DIR= to pristine, unconfigured
> 2.6.18 source. Now it works most of the time.
> 
> However, on some commands it does not:
> 
> iptables -t nat -A OUTPUT --match connmark --mark 22 -j RETURN
> iptables -t nat -A OUTPUT -j CONNMARK --set-mark 22
> 
> give the same error and in dmesg I see:
> 
> ip_tables: connmark match: invalid size 24 != 12
> ip_tables: CONNMARK target: invalid size 24 != 12
> ip_tables: connmark match: invalid size 24 != 12
> ip_tables: CONNMARK target: invalid size 24 != 12
> 
> Same happens on MARK target.

The latest -git kernel includes compatibility functions for 32 bit
userspace. You need to compile your iptables without the
KERNEL_64_USERSPACE_32 thing though (edit main Makefile).
