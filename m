From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: ROUTE target broken under 2.6.18.3 kernel
Date: Fri, 1 Dec 2006 16:19:47 +0100 (CET)
Message-ID: <50267.84.123.236.132.1164986387.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I had problems with 2.6.19 kernel, appears to be some "binaries" problems
about iptables and kernel modules, then I pass to try the 2.6.18.3 kernel
to tests some things.

When I put -j ROUTE into -t mangle table and PREROUTING chain, I have no
problems, but when I try -j ROUTE into POSTROUTING chain, my system loss
all network access (and it is posible it crash, I'm not there to view
screen).

My system has:
   SMP kernel (dual Xeon 3,0 GHz)
   2.6.18.3 kernel + connlimit + layer7 + ROUTE patches
   1.3.5 iptables (FC5 distro sources) with connlimit + layer7 + ROUTE
patches (as I see, I only need change the makefile into distro sources
to allow connlimit and ROUTE work)

The command that break off network (and posibility crash the machine) is:

iptables -t mangle -A POSTROUTING -p tcp --dport msnp -j ROUTE --gw <mygw>
--continue

I have 2 uplinks with 2 diferents gw ip's, and I detected disconnection
problems with messenger clients (amsn, windows msn, msn-messenger, gaim,
etc....) and I only want to route all msn traffic into only one uplink.

Any help about this? It is really a bug with ROUTE Patch and 2.6.8.3
kernel? Or its a bug with the 1.3.5 iptables version (FC5 distro sources).

Please, help me a bit to solve this problem.

Thanks
