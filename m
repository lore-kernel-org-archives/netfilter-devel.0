From: Luca Raggi <llr@raggi.org>
Subject: SNAT & default route
Date: Sun, 22 Jun 2003 23:19:16 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19UKfY-00043o-00@raggi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi;

I'm trying to do source NAT and multiple-provider outbound load balancing
at the same time, and while everything works with respect to incoming
packets, I can't seem to get outbound packets out through the right
device/gateway.

I tried the following approaches:

- Using MARK, CONNMARK, and fwmark to select an iproute2 table with the
  right default gateway. While the marks are set correctly (for both 
packet
  N=1 and packets N>=2), in the end the routing decision is apparently
  discarded, and the main default is used anyways (for all values of N.)
  This only happens for forwarded/SNAT'ed packets, however. Locally
  originating packets and non-SNAT'ed forwarded packets get routed
  correctly (via "ip rule from"'s that point to the same tables that the
  higher-priority "ip rule fwmark"'s point to.)

- Using SMASQ instead of SNAT. Here, again, the device indicated with
  --via-dev doesn't get used after all, and the main default is used
  instead. This is rather perplexing, since being able to choose the
  output device is SMASQ's raison d'etre.

- Using the ROUTE target in various places to try to force the correct
  behavior. Unfortunately, trying to ROUTE before SNAT'ing bypasses the
  SNAT'ing, and ROUTE'ing after the SNAT'ing is apparently impossible,
  since there's no chain after the nat/POSTROUTING chain in which to place
  the ROUTE rule.

Can anyone offer a hint as to what I may be running into here? Any 
pointers
as to where to look in the kernel source (2.4.21) would also be helpful.

Thanks!

Regards,
Luca Raggi
