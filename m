From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: xt_tcpudp: fix wrong struct in udp_checkentry
Date: Thu, 30 Aug 2007 09:04:09 +0200
Message-ID: <46D66BE9.5040304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030405040307050905040507"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------030405040307050905040507
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

the attached patch fixes an incorrectly used structure
in xt_tcpudp, which apparently causes problems on CRIS.

Please apply, thanks.


--------------030405040307050905040507
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: xt_tcpudp: fix wrong struct in udp_checkentry

It doesn't seem to have any effect on the x86 architecture but it does
have effect on the Axis CRIS architecture.

Signed-off-by: Jesper Bengtsson <jesper.bengtsson_at_axis.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 91574ca32eb052b31c976581e9723735e9acb53f
tree 1dbeb1356c2ec6051460d5db3f29635d24716d74
parent b07d68b5ca4d55a16fab223d63d5fb36f89ff42f
author Patrick McHardy <kaber@trash.net> Thu, 30 Aug 2007 08:47:23 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 30 Aug 2007 08:47:23 +0200

 net/netfilter/xt_tcpudp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index ab7d845..223f9bd 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -188,7 +188,7 @@ udp_checkentry(const char *tablename,
 	       void *matchinfo,
 	       unsigned int hook_mask)
 {
-	const struct xt_tcp *udpinfo = matchinfo;
+	const struct xt_udp *udpinfo = matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);

--------------030405040307050905040507--
