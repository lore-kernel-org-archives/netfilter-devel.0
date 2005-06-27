From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Mon, 27 Jun 2005 23:31:50 +0200
Message-ID: <42C07046.10101@trash.net>
References: <42C03F2E.30706@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C03F2E.30706@eurodev.net>
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

Pablo Neira wrote:
> Hi Harald,
> 
> This patchset introduces tons of updates for the nfnetlink, ctnetlink
> and the conntrack event API. I haven't attached the file since it's that
> big, about 100K.
> 
> You can get an incremental diff against SVN from:
> http://people.netfilter.org/~pablo/ctnetlink-2.6.12/SVN-patches/ctnetlink-ctevent-nfnetlink-update-2.6.12.patch

I haven't looked at the patch for a long time, and it removes
and adds the whole file, so not sure if it is new ..

+		/* This is tricky but it works. ip_nat_setup_info needs the
+		 * hook number as parameter, so let's do the correct
+		 * conversion and run away */
+		if (*status & IPS_SRC_NAT_DONE)
+			hooknum = NF_IP_POST_ROUTING; /* IP_NAT_MANIP_SRC */
+		else if (*status & IPS_DST_NAT_DONE)
+			hooknum = NF_IP_PRE_ROUTING;  /* IP_NAT_MANIP_DST */
+		else
+			return -EINVAL; /* Missing NAT flags */

This doesn't work reliably, locally generated packets never enter
PRE_ROUTING but can be DNATed. I think the hook should be supplied
by the user.

Regards
Patrick
