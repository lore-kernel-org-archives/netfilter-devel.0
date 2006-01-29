From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] textsearch oops fix on 64-bit
Date: Sun, 29 Jan 2006 19:50:24 +0100
Message-ID: <43DD0E70.5060201@eurodev.net>
References: <20060128225456.GA14863@minastirith.cipherdyne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030201090606060608040607"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.org>
In-Reply-To: <20060128225456.GA14863@minastirith.cipherdyne.org>
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
--------------030201090606060608040607
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

Michael Rash wrote:
> When using the string match on kernels 2.6.14 through 2.6.15.1, I get an
> oops with Boyer-Moore on my AMD Athlon 64 processor (the Knuth-Morris-Pratt
> algorithm works fine).  The oops happens at load time for any Netfilter
> rule that attempts to use the string match.  I believe the problem stems
> from missing bounds checking on array indices in lib/ts_bm.c within
> compute_prefix_tbl().  Here is a patch against 2.6.15.1; I have tested it
> on both 32-bit and 64-bit processors and it seems to work.  If the patch
> looks ok, I will submit it to the kernel mailing list

I've revisited the current logic to calculate the good shift array and I
found more problems, my fault. Could you give a try to the patch
attached and tell me if it works for you?

Thanks.

-- 
Pablo

--------------030201090606060608040607
Content-Type: text/plain;
 name="fix-bm-goodsuffix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-bm-goodsuffix.patch"

[TEXTSEARCH] Fix broken good shift array calculation in Boyer-Moore

The current logic does not calculate correctly the good shift array:
Let x be the pattern that is being searched. Let y be the block of data. 
The good shift array aligns rightmost the segment:

x[i+1 ... m-1] = y[i+j+1 ... j+m-1]

with its rightmost occurrence in x that fulfils x[i] neq y[i+j].

In previous version, the good shift array for the pattern ANPANMAN is:
[1, 8, 3, 8, 8, 8, 8, 8]
and should be:
[1, 8, 3, 6, 6, 6, 6, 6]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/lib/ts_bm.c
===================================================================
--- net-2.6.git.orig/lib/ts_bm.c	2006-01-29 05:10:25.000000000 +0100
+++ net-2.6.git/lib/ts_bm.c	2006-01-29 05:25:47.000000000 +0100
@@ -94,10 +94,28 @@ next:			bs = bm->bad_shift[text[shift-i]
 	return UINT_MAX;
 }
 
+static int subpattern(u8 *pattern, int i, int j, int g)
+{
+	int x = i+g-1, y = j+g-1, ret = 0;
+
+	while(pattern[x--] == pattern[y--]) {
+		if (y < 0) {
+			ret = 1;
+			break;
+		}
+		if (--g == 0) {
+			ret = pattern[i-1] != pattern[j-1];
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static void compute_prefix_tbl(struct ts_bm *bm, const u8 *pattern,
 			       unsigned int len)
 {
-	int i, j, ended, l[ASIZE];
+	int i, j, g;
 
 	for (i = 0; i < ASIZE; i++)
 		bm->bad_shift[i] = len;
@@ -106,23 +124,15 @@ static void compute_prefix_tbl(struct ts
 
 	/* Compute the good shift array, used to match reocurrences 
 	 * of a subpattern */
-	for (i = 1; i < bm->patlen; i++) {
-		for (j = 0; j < bm->patlen && bm->pattern[bm->patlen - 1 - j]
-				== bm->pattern[bm->patlen - 1 - i - j]; j++);
-		l[i] = j;
-	}  
-
 	bm->good_shift[0] = 1;
 	for (i = 1; i < bm->patlen; i++)
 		bm->good_shift[i] = bm->patlen;
-	for (i = bm->patlen - 1; i > 0; i--)
-		bm->good_shift[l[i]] = i;
-	ended = 0;
-	for (i = 0; i < bm->patlen; i++) {
-		if (l[i] == bm->patlen - 1 - i)
-			ended = i;
-		if (ended)
-			bm->good_shift[i] = ended;
+        for (i = bm->patlen-1, g = 1; i > 0; g++, i--) {
+		for (j = i-1; j >= 1-g ; j--)
+			if (subpattern(bm->pattern, i, j, g)) {
+				bm->good_shift[g] = bm->patlen-j-g;
+				break;
+			}
 	}
 }
 

--------------030201090606060608040607--
