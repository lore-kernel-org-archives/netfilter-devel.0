From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Mon, 22 Sep 2003 18:06:29 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6EAD85.1070707@snapgear.com>
References: <20030905115534.GD665@obroa-skai.de.gnumonks.org> <3F5D91DC.3030706@snapgear.com> <20030921140546.GB20986@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020205010909070102010100"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030921140546.GB20986@sunbeam.de.gnumonks.org>
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
--------------020205010909070102010100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> great.  NAT works also?

Actually, I've only tested with NAT.

> However, there were some problems with running a PPTP daemon on the PPTP
> NAT box at the same time, and I never really understand the source of
> the problem [most likely because I didn't have enough time].  So I went
> for the 'quick fix now, real solution later' approach, that ended up
> with the 25_natcore-nohelper.patch.

If I recall correctly, the problem was that local PPTP connections did not
work unless you also had CONFIG_IP_NF_NAT_LOCAL enabled.  This was because
the helper/expect were being called at LOCAL_OUT, but not at LOCAL_IN,
and so the manips were only created for one direction.

Is it possible to change it so that the helper is not called at all
at LOCAL_OUT unless CONFIG_IP_NF_NAT_LOCAL is enabled?

Btw, why do we even have the LOCAL_OUT hook for nat when
CONFIG_IP_NF_NAT_LOCAL is disabled?

>>The second concern is that I believe we choose the NATed call ID
>>based on the TCP source port prior to source NAT, which means we
>>may not get a unique call ID.  If you agree this is a problem
>>then I can try to fix it.
> 
> 
> Yes, this is a problem.  If you want to work on a fix, I'd be more to
> happy to integrate it.

I've attached a patch for this.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances

--------------020205010909070102010100
Content-Type: text/plain;
 name="pptp-nat-source.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-nat-source.patch"

--- netfilter-extensions/helpers/pptp/ip_nat_pptp.c	4 Jul 2003 19:05:57 -0000	1.4
+++ netfilter-extensions/helpers/pptp/ip_nat_pptp.c	22 Sep 2003 04:41:46 -0000
@@ -170,7 +170,7 @@
 			/* save original call ID in nat_info */
 			nat_pptp_info->pns_call_id = ct_pptp_info->pns_call_id;
 
-			new_callid = tcph->source;
+			new_callid = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
 			/* save new call ID in ct info */
 			ct_pptp_info->pns_call_id = ntohs(new_callid);
 			break;

--------------020205010909070102010100--
