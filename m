From: Del Winiecki <delw@wildapache.net>
Subject: Apparent Memory Leak
Date: 05 Mar 2003 13:11:00 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046895061.1738.88.camel@thizzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
My Linux router using DNAT/SNAT/mangle etc, all works as expected, but
am seeing what appears to be a memory leak. As traffic increases,
available ram disappears and never returns. Eventually it begins to page
applications to disk, and then I have to reboot it. With no network
traffic, used memory is static.
I see a bug at RedHat where someone else had the exact same problem.
Does anyone know of any memory de-allocation problems at the net buffer
level?
This router handles internet traffic for 2 isp's and 7 company LAN's, so
moderately complex iptables setup, tbf rate management for some.

IPTABLES version 1.2.5
RedHat kernel 2.4.18-24.7.x  for i686 
running on an intel pentium 4 - 2.4ghz, ASUS P4B533 motherboard with
1gbyte ram.(5) 3com 3c905ctx nic cards, (1) Sangoma T1 WAN card.

The problem occurs with or without the Sangoma card present in the
system.

Regards,
Del W.
