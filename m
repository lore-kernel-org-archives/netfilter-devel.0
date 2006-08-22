From: Patrick McHardy <kaber@trash.net>
Subject: [TEXTSEARCH]: Fix Boyer Moore initialization bug
Date: Tue, 22 Aug 2006 04:07:57 +0200
Message-ID: <44EA66FD.8050502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060902040501030508000800"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org, Adrian Bunk <bunk@stusta.de>
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
--------------060902040501030508000800
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

this fixes an initialization bug in the bm textsearch
algorithm affecting the netfilter string match (the
only user AFAIK). Please apply to 2.6.18, thanks.

@stable maintainers: the bm_ts author asked me to also
submit this to -stable, please apply.


--------------060902040501030508000800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[TEXTSEARCH]: Fix Boyer Moore initialization bug

The pattern is set after trying to compute the prefix table, which tries
to use it. Initialize it before calling compute_prefix_tbl, make
compute_prefix_tbl consistently use only the data from struct ts_bm
and remove the now unnecessary arguments.

Signed-off-by: Michael Rash <mbr@cipherdyne.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 96d2404fab775fc7aebf06956bd3ea5e8996b0f7
tree 682dee25bd20e0d85f909fbf5967db2844d58253
parent 8ebd6bb0f469f2759f39e73adee6916a3d975393
author Michael Rash <mbr@cipherdyne.org> Thu, 17 Aug 2006 17:43:21 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 17 Aug 2006 17:43:21 +0200

 lib/ts_bm.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 0110e44..d90822c 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -111,15 +111,14 @@ static int subpattern(u8 *pattern, int i
 	return ret;
 }
 
-static void compute_prefix_tbl(struct ts_bm *bm, const u8 *pattern,
-			       unsigned int len)
+static void compute_prefix_tbl(struct ts_bm *bm)
 {
 	int i, j, g;
 
 	for (i = 0; i < ASIZE; i++)
-		bm->bad_shift[i] = len;
-	for (i = 0; i < len - 1; i++)
-		bm->bad_shift[pattern[i]] = len - 1 - i;
+		bm->bad_shift[i] = bm->patlen;
+	for (i = 0; i < bm->patlen - 1; i++)
+		bm->bad_shift[bm->pattern[i]] = bm->patlen - 1 - i;
 
 	/* Compute the good shift array, used to match reocurrences 
 	 * of a subpattern */
@@ -150,8 +149,8 @@ static struct ts_config *bm_init(const v
 	bm = ts_config_priv(conf);
 	bm->patlen = len;
 	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
-	compute_prefix_tbl(bm, pattern, len);
 	memcpy(bm->pattern, pattern, len);
+	compute_prefix_tbl(bm);
 
 	return conf;
 }

--------------060902040501030508000800--
