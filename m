From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: New ROUTE patch does not work with conntrack+nat disabled
Date: Mon, 24 Jan 2005 19:56:24 +0100
Message-ID: <1106592985.3540.5.camel@krak.odu>
References: <Pine.LNX.4.61.0501201253440.5089@bizon.gios.gov.pl>
	<1106229501.3807.4.camel@nienna.balabit>
	<Pine.LNX.4.61.0501241856210.10054@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-IjTkmgIfW1U/deCPHkCW"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Cedric de Launois <delaunois@info.ucl.ac.be>, Patrick Schaaf <bof@bof.de>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.61.0501241856210.10054@bizon.gios.gov.pl>
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


--=-IjTkmgIfW1U/deCPHkCW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

On Mon, 2005-01-24 at 18:58 +0100, Krzysztof Oledzki wrote:
> Sweet :) What about 2.6.11-rc2 kernel? There is no "initialized" in the 
> "struct ip_nat_info".

  The 'initialized' field was removed, now NAT uses status bits to mark
already processed connections. Does the attached patch (to be applied
onto latest POM-ng) help?

-- 
  Krisztian Kovacs

--=-IjTkmgIfW1U/deCPHkCW
Content-Disposition: attachment; filename=pom-ng_ROUTE_NAT_update.patch
Content-Type: text/x-patch; name=pom-ng_ROUTE_NAT_update.patch;
	charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
===================================================================
--- ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(revision 3612)
+++ ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(working copy)
@@ -447,11 +447,13 @@
 	    - to never be deleted, not in any hashes */
 	atomic_set(&route_tee_track.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
-	/* Initialize fake conntrack so that NAT will skip it */
-	route_tee_track.nat.info.initialized |= 
-		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+	route_tee_track.status |= IPS_CONFIRMED;
 
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	/*  - look like it has already been processed by NAT */
+	route_tee_track.status = (IPS_SRC_NAT_DONE | IPS_DST_NAT_DONE);
+#endif
+
 	return ipt_register_target(&ipt_route_reg);
 }
 

--=-IjTkmgIfW1U/deCPHkCW--
