From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target : kernel 2.6 fix for --gw option
Date: Wed, 10 Nov 2004 17:33:10 +0100
Message-ID: <1100104390.1748.95.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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

Hi all,

Here a small patch to fix a bug in the kernel 2.6 version of the ROUTE
target.

SYMPTOM : when a packet is rerouted towards a gateway, the destination
          MAC address of the packet is not change appropriately.

CAUSE : in the route() function of the ROUTE target, a wrong field
        (fl.fld_dst) is used to alter the IP address of the next hop.
        The right field is fl.fl4_dst for IPv4 packets.
        This field only appears for kernels 2.6.x.

SOLUTION :

    modify
       /* The destination address may be overloaded by the target */
       if (route_info->gw)
               fl.fld_dst = route_info->gw;

    by
       /* The destination address may be overloaded by the target */
       if (route_info->gw)
               fl.fl4_dst = route_info->gw;

The patch is attached.

Cedric
