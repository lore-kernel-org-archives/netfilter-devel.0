From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] Boyer Moore textsearch bug fix
Date: Wed, 16 Aug 2006 23:16:07 -0400
Message-ID: <20060817031607.GA7484@minastirith>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
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

Hi -

The patch below fixes Bugzilla #501:

The compute_prefix_tbl() function in lib/ts_bm.c is called before
bm->pattern is initialized, and this results in the following issue.
If the rule below is put within the OUTPUT chain (note the slightly
repetitive pattern "aaabbbccc" which I think is necessary to expose
the fact that the good_shift array is not getting populated
correctly):

iptables -I OUTPUT -p tcp --dport 80 -m string --string "aaabbbccc" \
--algo bm -j LOG --log-prefix "bm "

...then the issuing the following commands fail to match the rule (no
log message is generated):

echo "1aaabbbccc" |nc <someserver> 80
echo "12aaabbbccc" |nc <someserver> 80
echo "1234aaabbbccc" |nc <someserver> 80

...but these do match:

echo "aaabbbccc" |nc <someserver> 80
echo "123aaabbbccc" |nc <someserver> 80

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F


--- linux-2.6.17.8/lib/ts_bm.c.orig	2006-08-16 21:17:38.000000000 -0400
+++ linux-2.6.17.8/lib/ts_bm.c	2006-08-16 21:17:56.000000000 -0400
@@ -151,8 +151,8 @@
 	bm = ts_config_priv(conf);
 	bm->patlen = len;
 	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
-	compute_prefix_tbl(bm, pattern, len);
 	memcpy(bm->pattern, pattern, len);
+	compute_prefix_tbl(bm, pattern, len);
 
 	return conf;
 }
