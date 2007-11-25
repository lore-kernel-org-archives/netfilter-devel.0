From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [oops] in text matching
Date: Sun, 25 Nov 2007 20:30:25 +0100
Message-ID: <4749CD51.1000906@netfilter.org>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac> <47394ABA.3070109@trash.net> <47499708.5070502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060100070402080502020508"
Cc: andrei.popa@i-neo.ro, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36211 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753308AbXKYTai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:30:38 -0500
In-Reply-To: <47499708.5070502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060100070402080502020508
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Andrei Popa wrote:
>>> On Sat, 2007-11-10 at 13:57 +0100, Patrick McHardy wrote:
>>>> Please try this patch.
>>>
>>> it's ok now:
>>>
>>> test ~ # iptables -I INPUT -p tcp --dport 80 -m string --algo bm
>>> --string "$MyNick" -j DROP
>>> iptables: Invalid argument
>>
>>
>> Thanks, thats whats expected. The patch is suboptimal though
>> since it should really allow patterns of length zero. Pablo,
>> the naive approach would be to ignore patlen == 0 in the
>> initialization path and return the current position in bm_find().
>> But I'm guessing there's a better way to handle this case,
>> could you look into this please? Thanks.
> 
> 
> Pablo? I would prefer to get this fixed before 2.6.24, unless
> there's a better fix I'm going to include my patch to reject
> pattern lengths of 0. Thanks.

Sorry for the late reply. Why should we accept zero length patterns?
Would you consider this patch? It keeps consistent the return value of
all textsearch approaches when a zero length pattern is passed.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060100070402080502020508
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

[PATCH] Do not allow zero length patterns in the textsearch infrastructure

If a zero length pattern is passed then return EINVAL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/lib/textsearch.c b/lib/textsearch.c
index 88c98a2..be8bda3 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -7,7 +7,7 @@
  *		2 of the License, or (at your option) any later version.
  *
  * Authors:	Thomas Graf <tgraf@suug.ch>
- * 		Pablo Neira Ayuso <pablo@eurodev.net>
+ * 		Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * ==========================================================================
  *
@@ -250,7 +250,8 @@ unsigned int textsearch_find_continuous(struct ts_config *conf,
  *       the various search algorithms.
  *
  * Returns a new textsearch configuration according to the specified
- *         parameters or a ERR_PTR().
+ * parameters or a ERR_PTR(). If a zero length pattern is passed, this
+ * function returns EINVAL.
  */
 struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 				     unsigned int len, gfp_t gfp_mask, int flags)
@@ -259,6 +260,9 @@ struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 	struct ts_config *conf;
 	struct ts_ops *ops;
 	
+	if (len == 0)
+		return ERR_PTR(-EINVAL);
+
 	ops = lookup_ts_algo(algo);
 #ifdef CONFIG_KMOD
 	/*

--------------060100070402080502020508--
