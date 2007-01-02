From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: dst cache overflow
Date: Tue, 2 Jan 2007 23:24:13 +0100 (CET)
Message-ID: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070102232413_19906"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, lartc@mailman.ds9a.nl,
	netfilter@lists.netfilter.org
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

------=_20070102232413_19906
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi all, I'm having this problem with this system configuration:
   1) iptables 1.3.7
   2) kernel 2.6.19.1
   3) SMP computer
   4) 2 external links + 2 internal (bridged).

Some hours after the system is working without any troubles, all network
devices stop respond.

Anyone could help me to fix this problem?

Googling some ours I detect that this was a problem with old kernels and
were solved with 2.6.11 kernel version.

Any help will be appretiated.

Regards.

P.D.: With MASQUERADE the problem begans more quickly than with SNAT target.
------=_20070102232413_19906
Content-Type: text/plain; name="dst_overflow_error.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dst_overflow_error.txt"

Dec 30 00:50:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:50:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:50:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:51:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:51:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:27 cura kernel: dst cache overflow
Dec 30 00:52:27 cura kernel: MASQUERADE: No route: Rusty's brain broke!
Dec 30 00:52:27 cura kernel: dst cache overflow
Dec 30 00:52:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:28 cura kernel: dst cache overflow
Dec 30 00:52:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:32 cura kernel: printk: 15 messages suppressed.
Dec 30 00:52:32 cura kernel: dst cache overflow
Dec 30 00:52:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:37 cura kernel: printk: 40 messages suppressed.
Dec 30 00:52:37 cura kernel: dst cache overflow
Dec 30 00:52:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:42 cura kernel: printk: 47 messages suppressed.
Dec 30 00:52:42 cura kernel: dst cache overflow
Dec 30 00:52:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:47 cura kernel: printk: 65 messages suppressed.
Dec 30 00:52:47 cura kernel: dst cache overflow
Dec 30 00:52:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:52 cura kernel: printk: 67 messages suppressed.
Dec 30 00:52:52 cura kernel: dst cache overflow
Dec 30 00:52:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:57 cura kernel: printk: 51 messages suppressed.
Dec 30 00:52:57 cura kernel: dst cache overflow
Dec 30 00:52:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:02 cura kernel: printk: 52 messages suppressed.
Dec 30 00:53:02 cura kernel: dst cache overflow
Dec 30 00:53:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:07 cura kernel: printk: 36 messages suppressed.
Dec 30 00:53:07 cura kernel: dst cache overflow
Dec 30 00:53:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:12 cura kernel: printk: 44 messages suppressed.
Dec 30 00:53:12 cura kernel: dst cache overflow
Dec 30 00:53:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:17 cura kernel: printk: 50 messages suppressed.
Dec 30 00:53:17 cura kernel: dst cache overflow
Dec 30 00:53:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:22 cura kernel: printk: 40 messages suppressed.
Dec 30 00:53:22 cura kernel: dst cache overflow
Dec 30 00:53:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:27 cura kernel: printk: 58 messages suppressed.
Dec 30 00:53:27 cura kernel: dst cache overflow
Dec 30 00:53:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:32 cura kernel: printk: 53 messages suppressed.
Dec 30 00:53:32 cura kernel: dst cache overflow
Dec 30 00:53:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:37 cura kernel: printk: 59 messages suppressed.
Dec 30 00:53:37 cura kernel: dst cache overflow
Dec 30 00:53:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:42 cura kernel: printk: 33 messages suppressed.
Dec 30 00:53:42 cura kernel: dst cache overflow
Dec 30 00:53:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:47 cura kernel: printk: 46 messages suppressed.
Dec 30 00:53:47 cura kernel: dst cache overflow
Dec 30 00:53:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:52 cura kernel: printk: 25 messages suppressed.
Dec 30 00:53:52 cura kernel: dst cache overflow
Dec 30 00:53:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:53:57 cura kernel: printk: 25 messages suppressed.
Dec 30 00:53:57 cura kernel: dst cache overflow
Dec 30 00:53:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:53:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:02 cura kernel: printk: 17 messages suppressed.
Dec 30 00:54:02 cura kernel: dst cache overflow
Dec 30 00:54:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:07 cura kernel: printk: 13 messages suppressed.
Dec 30 00:54:07 cura kernel: dst cache overflow
Dec 30 00:54:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:12 cura kernel: printk: 16 messages suppressed.
Dec 30 00:54:12 cura kernel: dst cache overflow
Dec 30 00:54:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:17 cura kernel: printk: 33 messages suppressed.
Dec 30 00:54:17 cura kernel: dst cache overflow
Dec 30 00:54:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:22 cura kernel: printk: 25 messages suppressed.
Dec 30 00:54:22 cura kernel: dst cache overflow
Dec 30 00:54:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:27 cura kernel: printk: 19 messages suppressed.
Dec 30 00:54:27 cura kernel: dst cache overflow
Dec 30 00:54:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:32 cura kernel: printk: 19 messages suppressed.
Dec 30 00:54:32 cura kernel: dst cache overflow
Dec 30 00:54:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:37 cura kernel: printk: 32 messages suppressed.
Dec 30 00:54:37 cura kernel: dst cache overflow
Dec 30 00:54:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:42 cura kernel: printk: 27 messages suppressed.
Dec 30 00:54:42 cura kernel: dst cache overflow
Dec 30 00:54:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:47 cura kernel: printk: 41 messages suppressed.
Dec 30 00:54:47 cura kernel: dst cache overflow
Dec 30 00:54:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:52 cura kernel: printk: 31 messages suppressed.
Dec 30 00:54:52 cura kernel: dst cache overflow
Dec 30 00:54:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:54:57 cura kernel: printk: 23 messages suppressed.
Dec 30 00:54:57 cura kernel: dst cache overflow
Dec 30 00:54:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:54:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:02 cura kernel: printk: 35 messages suppressed.
Dec 30 00:55:02 cura kernel: dst cache overflow
Dec 30 00:55:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:07 cura kernel: printk: 44 messages suppressed.
Dec 30 00:55:07 cura kernel: dst cache overflow
Dec 30 00:55:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:12 cura kernel: printk: 49 messages suppressed.
Dec 30 00:55:12 cura kernel: dst cache overflow
Dec 30 00:55:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:17 cura kernel: printk: 39 messages suppressed.
Dec 30 00:55:17 cura kernel: dst cache overflow
Dec 30 00:55:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:22 cura kernel: printk: 37 messages suppressed.
Dec 30 00:55:22 cura kernel: dst cache overflow
Dec 30 00:55:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:27 cura kernel: printk: 43 messages suppressed.
Dec 30 00:55:27 cura kernel: dst cache overflow
Dec 30 00:55:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:32 cura kernel: printk: 62 messages suppressed.
Dec 30 00:55:32 cura kernel: dst cache overflow
Dec 30 00:55:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:37 cura kernel: printk: 40 messages suppressed.
Dec 30 00:55:37 cura kernel: dst cache overflow
Dec 30 00:55:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:42 cura kernel: printk: 17 messages suppressed.
Dec 30 00:55:42 cura kernel: dst cache overflow
Dec 30 00:55:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:47 cura kernel: printk: 22 messages suppressed.
Dec 30 00:55:47 cura kernel: dst cache overflow
Dec 30 00:55:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:52 cura kernel: printk: 22 messages suppressed.
Dec 30 00:55:52 cura kernel: dst cache overflow
Dec 30 00:55:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:55:57 cura kernel: printk: 16 messages suppressed.
Dec 30 00:55:57 cura kernel: dst cache overflow
Dec 30 00:55:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:55:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:02 cura kernel: printk: 23 messages suppressed.
Dec 30 00:56:02 cura kernel: dst cache overflow
Dec 30 00:56:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:07 cura kernel: printk: 13 messages suppressed.
Dec 30 00:56:07 cura kernel: dst cache overflow
Dec 30 00:56:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:12 cura kernel: printk: 15 messages suppressed.
Dec 30 00:56:12 cura kernel: dst cache overflow
Dec 30 00:56:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:17 cura kernel: printk: 30 messages suppressed.
Dec 30 00:56:17 cura kernel: dst cache overflow
Dec 30 00:56:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:22 cura kernel: printk: 31 messages suppressed.
Dec 30 00:56:22 cura kernel: dst cache overflow
Dec 30 00:56:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:27 cura kernel: printk: 36 messages suppressed.
Dec 30 00:56:27 cura kernel: dst cache overflow
Dec 30 00:56:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:32 cura kernel: printk: 63 messages suppressed.
Dec 30 00:56:32 cura kernel: dst cache overflow
Dec 30 00:56:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:37 cura kernel: printk: 44 messages suppressed.
Dec 30 00:56:37 cura kernel: dst cache overflow
Dec 30 00:56:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:42 cura kernel: printk: 50 messages suppressed.
Dec 30 00:56:42 cura kernel: dst cache overflow
Dec 30 00:56:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:47 cura kernel: printk: 30 messages suppressed.
Dec 30 00:56:47 cura kernel: dst cache overflow
Dec 30 00:56:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:52 cura kernel: printk: 38 messages suppressed.
Dec 30 00:56:52 cura kernel: dst cache overflow
Dec 30 00:56:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:56:57 cura kernel: printk: 42 messages suppressed.
Dec 30 00:56:57 cura kernel: dst cache overflow
Dec 30 00:56:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:56:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:02 cura kernel: printk: 35 messages suppressed.
Dec 30 00:57:02 cura kernel: dst cache overflow
Dec 30 00:57:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:07 cura kernel: printk: 43 messages suppressed.
Dec 30 00:57:07 cura kernel: dst cache overflow
Dec 30 00:57:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:12 cura kernel: printk: 33 messages suppressed.
Dec 30 00:57:12 cura kernel: dst cache overflow
Dec 30 00:57:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:17 cura kernel: printk: 24 messages suppressed.
Dec 30 00:57:17 cura kernel: dst cache overflow
Dec 30 00:57:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:22 cura kernel: printk: 30 messages suppressed.
Dec 30 00:57:22 cura kernel: dst cache overflow
Dec 30 00:57:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:27 cura kernel: printk: 17 messages suppressed.
Dec 30 00:57:27 cura kernel: dst cache overflow
Dec 30 00:57:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:32 cura kernel: printk: 21 messages suppressed.
Dec 30 00:57:32 cura kernel: dst cache overflow
Dec 30 00:57:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:37 cura kernel: printk: 21 messages suppressed.
Dec 30 00:57:37 cura kernel: dst cache overflow
Dec 30 00:57:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:42 cura kernel: printk: 32 messages suppressed.
Dec 30 00:57:42 cura kernel: dst cache overflow
Dec 30 00:57:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:47 cura kernel: printk: 27 messages suppressed.
Dec 30 00:57:47 cura kernel: dst cache overflow
Dec 30 00:57:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:52 cura kernel: printk: 29 messages suppressed.
Dec 30 00:57:52 cura kernel: dst cache overflow
Dec 30 00:57:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:57:57 cura kernel: printk: 36 messages suppressed.
Dec 30 00:57:57 cura kernel: dst cache overflow
Dec 30 00:57:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:57:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:02 cura kernel: printk: 30 messages suppressed.
Dec 30 00:58:02 cura kernel: dst cache overflow
Dec 30 00:58:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:07 cura kernel: printk: 36 messages suppressed.
Dec 30 00:58:07 cura kernel: dst cache overflow
Dec 30 00:58:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:12 cura kernel: printk: 31 messages suppressed.
Dec 30 00:58:12 cura kernel: dst cache overflow
Dec 30 00:58:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:17 cura kernel: printk: 37 messages suppressed.
Dec 30 00:58:17 cura kernel: dst cache overflow
Dec 30 00:58:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:22 cura kernel: printk: 45 messages suppressed.
Dec 30 00:58:22 cura kernel: dst cache overflow
Dec 30 00:58:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:27 cura kernel: printk: 39 messages suppressed.
Dec 30 00:58:27 cura kernel: dst cache overflow
Dec 30 00:58:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:32 cura kernel: printk: 54 messages suppressed.
Dec 30 00:58:32 cura kernel: dst cache overflow
Dec 30 00:58:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:37 cura kernel: printk: 31 messages suppressed.
Dec 30 00:58:37 cura kernel: dst cache overflow
Dec 30 00:58:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:42 cura kernel: printk: 26 messages suppressed.
Dec 30 00:58:42 cura kernel: dst cache overflow
Dec 30 00:58:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:47 cura kernel: printk: 49 messages suppressed.
Dec 30 00:58:47 cura kernel: dst cache overflow
Dec 30 00:58:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:52 cura kernel: printk: 44 messages suppressed.
Dec 30 00:58:52 cura kernel: dst cache overflow
Dec 30 00:58:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:58:57 cura kernel: printk: 37 messages suppressed.
Dec 30 00:58:57 cura kernel: dst cache overflow
Dec 30 00:58:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:58:58 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:00 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:00 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:02 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:02 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:02 cura kernel: printk: 37 messages suppressed.
Dec 30 00:59:02 cura kernel: dst cache overflow
Dec 30 00:59:04 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:04 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:06 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:06 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:07 cura kernel: printk: 21 messages suppressed.
Dec 30 00:59:07 cura kernel: dst cache overflow
Dec 30 00:59:08 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:08 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:10 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:10 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:12 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:12 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:12 cura kernel: printk: 19 messages suppressed.
Dec 30 00:59:12 cura kernel: dst cache overflow
Dec 30 00:59:14 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:14 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:16 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:16 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:17 cura kernel: printk: 24 messages suppressed.
Dec 30 00:59:17 cura kernel: dst cache overflow
Dec 30 00:59:18 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:18 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:20 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:20 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:22 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:22 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:22 cura kernel: printk: 28 messages suppressed.
Dec 30 00:59:22 cura kernel: dst cache overflow
Dec 30 00:59:24 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:24 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:26 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:26 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:27 cura kernel: printk: 18 messages suppressed.
Dec 30 00:59:27 cura kernel: dst cache overflow
Dec 30 00:59:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:33 cura kernel: printk: 21 messages suppressed.
Dec 30 00:59:33 cura kernel: dst cache overflow
Dec 30 00:59:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:37 cura kernel: printk: 19 messages suppressed.
Dec 30 00:59:37 cura kernel: dst cache overflow
Dec 30 00:59:38 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:38 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:40 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:40 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:42 cura kernel: printk: 12 messages suppressed.
Dec 30 00:59:42 cura kernel: dst cache overflow
Dec 30 00:59:42 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:42 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:44 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:44 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:46 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:46 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:47 cura kernel: printk: 14 messages suppressed.
Dec 30 00:59:47 cura kernel: dst cache overflow
Dec 30 00:59:48 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:48 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:50 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:50 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:52 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:52 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:52 cura kernel: printk: 18 messages suppressed.
Dec 30 00:59:52 cura kernel: dst cache overflow
Dec 30 00:59:54 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:54 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:56 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:56 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:59:57 cura kernel: printk: 21 messages suppressed.
Dec 30 00:59:57 cura kernel: dst cache overflow
Dec 30 00:59:58 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:59:58 cura kernel: zlan0: topology change detected, propagating
------=_20070102232413_19906--
