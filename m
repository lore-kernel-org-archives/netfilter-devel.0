From: Pablo Neira <pablo@eurodev.net>
Subject: [Fwd: netfilter.diff resend]
Date: Wed, 17 Mar 2004 14:23:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4058515C.5030803@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090101020306020204030504"
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

This is a multi-part message in MIME format.
--------------090101020306020204030504
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Sergio Montero resent a netfilter's related patch to the linux-net 
maillist which fixes a circular dependency in 2.4 branch. It's not 
serious. Anyway, can someone confirm that the patch is ok?

thanks,
Pablo

P.S: actually i'm not sure if forwarding this email is the correct 
thing, if it's not, please let me know.

--------------090101020306020204030504
Content-Type: message/rfc822;
 name="netfilter.diff resend"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="netfilter.diff resend"

Return-Path: <linux-net-owner@vger.kernel.org>
Delivered-To: pablo@eurodev.net
Received: (qmail 22686 invoked from network); 17 Mar 2004 11:18:56 -0000
Received: from unknown (HELO vger.kernel.org) (67.72.78.212)
  by 172.26.0.2 with SMTP; 17 Mar 2004 11:18:56 -0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261375AbUCQLVG (ORCPT <rfc822;pablo@eurodev.net>);
	Wed, 17 Mar 2004 06:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261376AbUCQLVG
	(ORCPT <rfc822;linux-net-outgoing>); Wed, 17 Mar 2004 06:21:06 -0500
Received: from no-access-servers.fe.up.pt ([193.136.33.243]:53846 "EHLO
	relay1.fe.up.pt") by vger.kernel.org with ESMTP id S261375AbUCQLVB
	(ORCPT <rfc822;linux-net@vger.kernel.org>);
	Wed, 17 Mar 2004 06:21:01 -0500
Received: from [192.168.53.50] ([192.168.53.50])
	by relay1.fe.up.pt (8.12.9p10/8.12.4) with ESMTP id i2HBKpgL007350;
	Wed, 17 Mar 2004 11:20:51 GMT
Subject: netfilter.diff resend
From: =?ISO-8859-1?Q?S=E9rgio?= Monteiro Basto <sergiomb@netcabo.pt>
Reply-To: sergiomb@netcabo.pt
To: netdev@oss.sgi.com, linux-net@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-hABst8yhzjr25jBuO5Zy"
Message-Id: <1079522450.2630.5.camel@darkstar>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-7) 
Date: Wed, 17 Mar 2004 11:20:51 +0000
Sender: linux-net-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-net@vger.kernel.org
X-Spam-Checker-Version: SpamAssassin 2.63 (2004-01-11) on
	Barad-Dur.eurodev.net
X-Spam-Level: 
X-Spam-Status: No, hits=-4.9 required=5.0 tests=BAYES_00 autolearn=ham
	version=2.63


--=-hABst8yhzjr25jBuO5Zy
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Hi

Can you apply this patch into kernel-2.4.2x ? for work with IP
Masquerade.

Reference:
http://lists.netfilter.org/pipermail/netfilter-devel/2002-November/009928.html

In begin, I apply this patch on redhat 7.3 box and thought this is a
specific problem of RedHat compiler, but I see exactly the same 
dependency dropped on a slackware-9.1 with kernel 2.4.25 and gcc3.3, do
me a favor and apply this mini patch.


On Wed, 2004-03-17 at 01:44, David S. Miller wrote: 
> On Tue, 16 Mar 2004 23:06:10 +0000
> Sérgio Monteiro Basto <sergiomb@netcabo.pt> wrote:
> 
> > Marcelo can you apply this patch? for work with IP Masquerade.
> 
> How come the netfilter people have not submitted this patch?
> I've never had any problems with the netfilter maintainers
> being puntual and sending me the patches that do need to be
> included.  So please contact Harald Welte and ask him to
> submit the patch if you think it's important.
> 
> Also, please use netdev@oss.sgi.com or linux-net@vger.kernel.org
> for networking patches and discussion, most net folks don't watch
> linux-kernel, thanks.
-- 
Sérgio M. B.

--=-hABst8yhzjr25jBuO5Zy
Content-Disposition: attachment; filename=netfilter.diff
Content-Type: text/x-patch; name=netfilter.diff; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

--- 2.4.20/include/linux/netfilter_ipv4/ip_conntrack.h.orig	Sat May 31 23:22:01 2003
+++ 2.4.20+/include/linux/netfilter_ipv4/ip_conntrack.h	Sun Jun  1 00:11:03 2003
@@ -156,7 +156,8 @@
 	union ip_conntrack_expect_help help;
 };
 
-#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+struct ip_conntrack_helper;
+
 struct ip_conntrack
 {
 	/* Usage count in here is 1 for hash table/destruct timer, 1 per skb,

--=-hABst8yhzjr25jBuO5Zy--

-
To unsubscribe from this list: send the line "unsubscribe linux-net" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------090101020306020204030504--
