From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: fix endless loop caused by invalid TPKT
 len
Date: Fri, 28 Apr 2006 16:18:59 +0200
Message-ID: <44522453.2040401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090407030100060504030405"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
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
--------------090407030100060504030405
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I ran the PROTOS c07-h2250v4 testsuite against the H.323 helper today
and found two bugs. I'm sending you both patches for review, if you
don't object I'll push them upstream in a couple of hours.


--------------090407030100060504030405
Content-Type: text/plain;
 name="x1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x1"

[NETFILTER]: H.323 helper: fix endless loop caused by invalid TPKT len

Then the TPKT len included in the packet is below the lowest valid value
of 4 an underflow occurs which results in an endless loop.

Found by testcase 0000058 from the PROTOS c07-h2250v4 testsuite.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5074fd5f2344bc58355868c75c8abcd4145cde84
tree e99ca72642028c42ef67852b4584b6fef1ebe98a
parent c257fd2cb88fe09a510c696e4bbd442a4ee9f6fe
author Patrick McHardy <kaber@trash.net> Fri, 28 Apr 2006 11:35:55 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Apr 2006 11:35:55 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 2c2fb70..518f581 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -162,6 +162,8 @@ static int get_tpkt_data(struct sk_buff 
 
 	/* Validate TPKT length */
 	tpktlen = tpkt[2] * 256 + tpkt[3];
+	if (tpktlen < 4)
+		goto clear_out;
 	if (tpktlen > tcpdatalen) {
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */

--------------090407030100060504030405--
