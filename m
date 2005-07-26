From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] NAT PPTP Set-Link-Info
Date: Tue, 26 Jul 2005 14:29:22 +1000
Message-ID: <42E5BC22.2030303@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080203010509040905040103"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080203010509040905040103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

NAT PPTP Set-Link-Info messages in the PAC->PNS direction.
These are sent by Windows Server 2003.

Note that Set-Link-Info messages do not need to be NATed in the
PNS->PAC direction, since we never NAT the PAC call id.

Tested for linux-2.4.29 only, but should also apply to both 2.6
versions in patch-o-matic-ng.

--------------080203010509040905040103
Content-Type: text/plain;
 name="pptp-set-link-info.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-set-link-info.patch"

Index: linux/net/ipv4/netfilter/ip_nat_pptp.c
===================================================================
--- linux/net/ipv4/netfilter/ip_nat_pptp.c	(revision 4151)
+++ linux/net/ipv4/netfilter/ip_nat_pptp.c	(working copy)
@@ -324,6 +324,9 @@
 	case PPTP_CALL_DISCONNECT_NOTIFY:
 		pcid = &pptpReq.disc->callID;
 		break;
+	case PPTP_SET_LINK_INFO:
+		pcid = &pptpReq.setlink->peersCallID;
+		break;
 
 	default:
 		DEBUGP("unknown inbound packet %s\n",

--------------080203010509040905040103--
