From: Michael Rash <mbr@cipherdyne.org>
Subject: Re: [PATCH] Boyer Moore textsearch bug fix
Date: Thu, 17 Aug 2006 10:46:54 -0400
Message-ID: <20060817144654.GA7849@minastirith>
References: <20060817031607.GA7484@minastirith> <44E47182.7010901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Rash <mbr@cipherdyne.org>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E47182.7010901@trash.net>
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

On Aug 17, 2006, Patrick McHardy wrote:

> Michael Rash wrote:
> > --- linux-2.6.17.8/lib/ts_bm.c.orig	2006-08-16 21:17:38.000000000 -0400
> > +++ linux-2.6.17.8/lib/ts_bm.c	2006-08-16 21:17:56.000000000 -0400
> > @@ -151,8 +151,8 @@
> >  	bm = ts_config_priv(conf);
> >  	bm->patlen = len;
> >  	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
> > -	compute_prefix_tbl(bm, pattern, len);
> >  	memcpy(bm->pattern, pattern, len);
> > +	compute_prefix_tbl(bm, pattern, len);
> 
> 
> Good catch, thanks. But since both pattern and len are also passed
> to compute_prefix_tbl as arguments, I think we should either make
> it use only those arguments, or remove those arguments and use only
> the values from struct ts_bm.
> 
> Please send a new patch and add a Signed-off-by line so I can
> apply it. Thanks.

Got it.  Here is a new patch.  Thanks.

--Mike


Signed-off-by: Michael Rash <mbr@cipherdyne.org>


--- linux-2.6.17.8/lib/ts_bm.c.orig	2006-08-16 21:17:38.000000000 -0400
+++ linux-2.6.17.8/lib/ts_bm.c	2006-08-17 10:35:25.000000000 -0400
@@ -112,15 +112,14 @@
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
@@ -151,8 +150,8 @@
 	bm = ts_config_priv(conf);
 	bm->patlen = len;
 	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
-	compute_prefix_tbl(bm, pattern, len);
 	memcpy(bm->pattern, pattern, len);
+	compute_prefix_tbl(bm);
 
 	return conf;
 }
