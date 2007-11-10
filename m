From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Sat, 10 Nov 2007 13:57:42 +0100
Message-ID: <4735AAC6.7040605@trash.net>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net> <1194547827.3298.5.camel@ierdnac>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010809040906060909080706"
Cc: netfilter-devel@vger.kernel.org
To: andrei.popa@i-neo.ro
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXKJM5o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Nov 2007 07:57:44 -0500
In-Reply-To: <1194547827.3298.5.camel@ierdnac>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010809040906060909080706
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Andrei Popa wrote:
> The oops is reproducible by this script (yyy are some IP addresses):
> 
> ...
> #$IPT -I INPUT -p tcp --dport 80 -m string --algo bm --string "$MyNick"
> -j DROP


I could reproduce it with an empty string - is $MyNick defined?
Please try this patch.


--------------010809040906060909080706
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index d90822c..5adb3ff 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -142,6 +142,9 @@ static struct ts_config *bm_init(const void *pattern, unsigned int len,
 	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
 	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
 
+	if (len == 0)
+		return ERR_PTR(-EINVAL);
+
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))
 		return conf;

--------------010809040906060909080706--
