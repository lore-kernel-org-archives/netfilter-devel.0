From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Advance seq-file position in exp_next_seq()
Date: Tue, 14 Jun 2005 02:56:37 +0200
Message-ID: <42AE2B45.7080106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060205020707050508050807"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------060205020707050508050807
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Dave,

a small fix for 2.6.12 if still possible: exp_next_seq() (used for
/proc/net/ip_conntracK_expect) doesn't advance the seq-file position.
I haven't tracked exactly why, but this makes the seq-file API show
(n+1)*(n/2) entries, with the first one showed n times, the second
one n-1 times, and so on.

Regards
Patrick

--------------060205020707050508050807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Advance seq-file position in exp_next_seq()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5cc89cae827217a8183d4eb1165cc32f804518fa
tree 7284df19ea5b31f63777407cec1adfd703fa7958
parent f268bb805a9777d5c82c7c1cb683b476d65f0c1b
author Patrick McHardy <kaber@trash.net> Sat, 11 Jun 2005 19:21:28 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 11 Jun 2005 19:21:28 +0200

 net/ipv4/netfilter/ip_conntrack_standalone.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -256,6 +256,7 @@ static void *exp_seq_next(struct seq_fil
 {
  	struct list_head *e = v;
 
+	++*pos;
 	e = e->next;
 
 	if (e == &ip_conntrack_expect_list)

--------------060205020707050508050807--
