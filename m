From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 25 Mar 2004 17:12:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080231132.1650.14.camel@nienna.balabit>
References: <Pine.LNX.4.44.0403171734230.11069-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+pqSK1ygFZXfde1OZN5T"
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403171734230.11069-200000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-+pqSK1ygFZXfde1OZN5T
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

On Wed, 2004-03-17 at 17:35, Henrik Nordstrom wrote:
> > On Wed, 2004-03-17 at 14:04, Henrik Nordstrom wrote:
> > > nothing. Thinking.. ah, now I get it. The problem is that you are doing
> > > traffic local->local and that the NAT code then gets confused as it sees
> > > the same packet twice in each direction, and as no null mapping was
> > > created the first time for the "local" side PREROUTING tries to when it
> > > sees the traffic coming "in" (from itself).
> > 
> >   Yes, this is the case.
> 
> The attached patch MAY fix this issue (completely untested, I always 
> compile with CONFIG_IP_NF_LOCAL_NAT enabled).

  I think the patch is buggy. The check should be

  if (!(info->initialized & (1 << maniptype))
      && !(ct->status & IPS_CONFIRMED))

instead of

  if (!(info->initialized & (1 << maniptype))
      && ct->status & IPS_CONFIRMED)

  Fixed patch attached. I've tested it on my UML testbed with stock
2.4.24, and seems to solve the problem.

-- 
 Regards,
   Krisztian KOVACS

--=-+pqSK1ygFZXfde1OZN5T
Content-Disposition: attachment; filename=renat_confirmed.patch
Content-Type: text/plain; name=renat_confirmed.patch; charset=iso-8859-2
Content-Transfer-Encoding: 7bit

--- ip_nat_standalone.c.orig	Fri Nov 28 19:26:21 2003
+++ ip_nat_standalone.c	Thu Mar 25 16:43:29 2004
@@ -114,7 +114,16 @@
 		WRITE_LOCK(&ip_nat_lock);
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
-		if (!(info->initialized & (1 << maniptype))) {
+		if (!(info->initialized & (1 << maniptype))
+#ifndef CONFIG_IP_NF_NAT_LOCAL
+		    /* If this session has already been confirmed we must not
+		     * touch it again even if there is no mapping set up.
+		     * Can only happen on local->local traffic with
+		     * CONFIG_IP_NF_NAT_LOCAL disabled.
+		     */
+		    && !(ct->status & IPS_CONFIRMED)
+#endif
+		    ) {
 			unsigned int ret;
 
 			if (ct->master

--=-+pqSK1ygFZXfde1OZN5T--
