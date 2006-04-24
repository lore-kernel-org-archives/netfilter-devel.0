From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: [H.323 Helper 3/3]: Update module's description in Kconfig
Date: Sun, 23 Apr 2006 23:40:59 -0400
Message-ID: <BAY109-DAV5EE9445BD35EB0CDD6C36B3BE0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0036_01C6672F.5FF392C0"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_0036_01C6672F.5FF392C0
Content-Type: text/plain; format=flowed; charset="GB18030"; reply-type=original
Content-Transfer-Encoding: 7bit

This patch is for 2.6.17-rc2.

Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
------=_NextPart_000_0036_01C6672F.5FF392C0
Content-Type: application/octet-stream;
	name="nath323-Kconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nath323-Kconfig"

diff -pruN linux-2.6.17-rc2.a/net/ipv4/netfilter/Kconfig =
linux-2.6.17-rc2.b/net/ipv4/netfilter/Kconfig=0A=
--- linux-2.6.17-rc2.a/net/ipv4/netfilter/Kconfig	2006-04-21 =
20:37:32.000000000 -0400=0A=
+++ linux-2.6.17-rc2.b/net/ipv4/netfilter/Kconfig	2006-04-21 =
20:49:48.000000000 -0400=0A=
@@ -181,10 +181,10 @@ config IP_NF_H323=0A=
 	  With this module you can support H.323 on a connection tracking/NAT=0A=
 	  firewall.=0A=
 =0A=
-	  This module supports RAS, Fast-start, H.245 tunnelling, RTP/RTCP=0A=
-	  and T.120 based data and applications including audio, video, FAX,=0A=
-	  chat, whiteboard, file transfer, etc. For more information, please=0A=
-	  see http://nath323.sourceforge.net/.=0A=
+	  This module supports RAS, Fast Start, H.245 Tunnelling, Call=0A=
+	  Forwarding, RTP/RTCP and T.120 based audio, video, fax, chat,=0A=
+	  whiteboard, file transfer, etc. For more information, please=0A=
+	  visit http://nath323.sourceforge.net/.=0A=
 =0A=
 	  If you want to compile it as a module, say 'M' here and read=0A=
 	  Documentation/modules.txt.  If unsure, say 'N'.=0A=

------=_NextPart_000_0036_01C6672F.5FF392C0--
