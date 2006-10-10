From: "Eric Leblond" <eric@inl.fr>
Subject: [PATCH 2/3] ulogd2 update
Date: Tue, 10 Oct 2006 23:59:21 +0200 (CEST)
Message-ID: <4287.83.156.0.70.1160517561.squirrel@mail.inl.fr>
References: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20061010235921_54075"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
To: netfilter-devel@lists.netfilter.org
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

------=_20061010235921_54075
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

This patch fixes a crash in ULOG input plugin due to a free on invalid value.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)
------=_20061010235921_54075
Content-Type: text/x-patch; name="ulogd2-free-crash.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ulogd2-free-crash.patch"

=== input/packet/ulogd_inppkt_ULOG.c
==================================================================
--- input/packet/ulogd_inppkt_ULOG.c	(revision 4621)
+++ input/packet/ulogd_inppkt_ULOG.c	(revision 4622)
@@ -58,12 +58,12 @@
 static struct ulogd_key output_keys[] = {
 	{ 
 		.type = ULOGD_RET_STRING, 
-		.flags = ULOGD_RETF_FREE, 
+		.flags = ULOGD_RETF_NONE, 
 		.name = "raw.mac", 
 	},
 	{
 		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_FREE,
+		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pkt",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_NETFILTER,
------=_20061010235921_54075--
