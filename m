From: Max Kellermann <max@duempel.org>
Subject: linux 2.6.10: ip_conntrack table overflowing
Date: Tue, 4 Jan 2005 13:40:34 +0100
Message-ID: <20050104124034.GA28010@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

yesterday, we upgraded four servers from 2.6.9 to 2.6.10. 12 hours
later (last night), all of them stopped responding; the conntrack
tables were full:

Jan  3 21:03:31 cfapro01 kernel: ip_conntrack: table full, dropping
packet.

We rebooted, and now there are more than 30000 connections in
/proc/net/ip_conntrack, but netstat only shows 400; example:

tcp      6 421183 ESTABLISHED src=XXremoteXX dst=YYlocalYY
sport=29800 dport=80 src=YYlocalYY dst=XXremoteXX sport=80
dport=29800 [ASSURED] mark=0 use=1

Seems like conntrack hasn't notice the connection has gone away
already, and will keep these for 5 days (default timeout). We have now
worked around this bug by reducing the timeout to 1 hour, I hope this
keeps the table from filling up until the "real" bug is found and
fixed.

Some information about the hardware:
- compaq, dual xeon p4, serverworks mainboard, 4 GB RAM
- cciss controller
- bcm57xx, intel e100 network adapters

We have KDB enabled on the four machines; they are still up and
running, with these stale connections. If someone needs more
information, let me know.

Regards,
Max Kellermann
