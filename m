From: Henrik Nordstrom <hno@marasystems.com>
Subject: [patch] REJECT incorrectly inherits the current nfmark to the generated RST packet
Date: Thu, 13 Jun 2002 19:31:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206131931.23688.hno@marasystems.com>
References: <20020613175053.J2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_BCNNPP9Z06EJEE80IB6G"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
In-Reply-To: <20020613175053.J2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_BCNNPP9Z06EJEE80IB6G
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

I have a smal patch not yet sent..

REJECT incorrecly inherits the current nfmark to the generated packet, 
inhibiting mangle from rerouting the generated RST packet correcly if 
attempting to set the same mark as the original packet that was REJECT:ed.

Attached you find a patch that makes sure the nfmark on the generated packet 
is cleared proper, allowing mangle to do it's job as usual for any other 
locally generated packets.

If the normal TCP/IP routing of locally generated packets accounted for nfmark 
this would obviously not be a problem, but then routing occurs before mangle 
on locally generated traffic so...

Reards
Henrik

Harald Welte wrote:
> Hi!
>
> I'm sorry if there are still any pending patches which I have missed to
> pick up from netfilter-devel.
>
> If anybody has still patches against netfilter/iptables CVS, which he wants
> to have included, please re-send them to me via private email.
>
> Thanks.

--------------Boundary-00=_BCNNPP9Z06EJEE80IB6G
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="REJECT_mark.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="REJECT_mark.patch"

--- linux-uml/net/ipv4/netfilter/ipt_REJECT.c.orig	Wed Jun 12 18:54:48 2002
+++ linux-uml/net/ipv4/netfilter/ipt_REJECT.c	Wed Jun 12 18:54:52 2002
@@ -74,6 +74,7 @@
 #ifdef CONFIG_NETFILTER_DEBUG
 	nskb->nf_debug = 0;
 #endif
+	nskb->nfmark = 0;
 
 	tcph = (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
 

--------------Boundary-00=_BCNNPP9Z06EJEE80IB6G
Content-Type: text/plain;
  charset="iso-8859-1";
  name="REJECT_mark.help"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="REJECT_mark.help"

Author: Henrik Nordstrom <hno@marasystems.com>
Status: working

Don't copy the nfmark value of the old packet into the new RST
packet when rejecting with TCP resets.

ip_route_output is not smart enough to know about nfmark routing,
and having the mark value set from start prevents mangle OUTPUT
from rerouting the packet later..

--------------Boundary-00=_BCNNPP9Z06EJEE80IB6G--
