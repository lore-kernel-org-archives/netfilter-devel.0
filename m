From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] ruleset: crash in path error when we build the
 xml tree
Date: Tue, 24 Feb 2015 14:43:40 +0100
Message-ID: <20150224134340.GB3589@salvia>
References: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
 <1424765433-4975-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34678 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbbBXNkQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 08:40:16 -0500
Content-Disposition: inline
In-Reply-To: <1424765433-4975-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 24, 2015 at 09:10:33AM +0100, Alvaro Neira Ayuso wrote:
> Crash when we try to release a tree that is not initialized.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/ruleset.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/src/ruleset.c b/src/ruleset.c
> index 9e8965c..8549130 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -669,8 +669,10 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
>  		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
>  
>  	tree = nft_mxml_build_tree(xml, "nftables", err, input);
> -	if (tree == NULL)
> -		goto err;
> +	if (tree == NULL) {
> +		nft_set_list_free(ctx.set_list);
> +		return -1;
> +	}

You have exactly the same problem in nft_ruleset_json_parse().

Have a look at the patch attached, it provides a template on how to
fix this.

Another different thing: it would be good to use the new 'buffer'
class to snprintf the ruleset.

--bg08WKrSYDhXBjb5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/ruleset.c b/src/ruleset.c
index 89ea344..86d8033 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -665,7 +665,7 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
-		goto err;
+		goto err1;
 
 	ctx.xml = tree;
 
@@ -673,16 +673,17 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 	while (nodecmd != NULL) {
 		cmd = nodecmd->value.opaque;
 		if (nft_ruleset_xml_parse_cmd(cmd, err, &ctx) < 0)
-			goto err;
+			goto err2;
 		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
 	}
 
 	nft_set_list_free(ctx.set_list);
 	mxmlDelete(tree);
 	return 0;
-err:
-	nft_set_list_free(ctx.set_list);
+err2:
 	mxmlDelete(tree);
+err1:
+	nft_set_list_free(ctx.set_list);
 	return -1;
 #else
 	errno = EOPNOTSUPP;

--bg08WKrSYDhXBjb5--
