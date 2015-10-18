From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: add interface wildcard matching
Date: Sun, 18 Oct 2015 22:14:27 +0200
Message-ID: <20151018201427.GA9765@salvia>
References: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
 <20151018183313.GA4386@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46057 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbbJRUHX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 16:07:23 -0400
Content-Disposition: inline
In-Reply-To: <20151018183313.GA4386@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 18, 2015 at 08:33:13PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Contrary to iptables, we use '*' as wildcard as in udev since the '+' can be
> > used as a valid interface name.
> 
> '*' can also be part of an interface name, seems only '/', ':', and ' '
> (space) are disallowed.

We can allow escaping the asterisk:

# nft --debug=netlink add rule test test iifname eth\\*
  ip test test 
    [ meta load iifname => reg 1 ]
    [ cmp eq reg 1 0x5c687465 0x0000002a 0x00000000 0x00000000 ]

This means, exact matching for those outthere using wildcards in
device name, see patch attached.

This applies on top of this initial patch.

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index a96efb7..69c01b9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -993,7 +993,7 @@ static void expr_string_wildcard(struct eval_ctx *ctx, struct expr *rel)
 	mpz_export_data(data, right->value, BYTEORDER_HOST_ENDIAN, len);
 
 	datalen = strlen(data) - 1;
-	if (data[datalen] != '*')
+	if (data[datalen] != '*' || data[datalen - 1] == '\\')
 		return;
 
 	data[datalen] = '\0';
diff --git a/src/scanner.l b/src/scanner.l
index 2a992d3..a902e8f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -114,7 +114,7 @@ range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
-wildcardstring	{string}\*
+wildcardstring	({string}\*|{string}\\\*)
 comment		#.*$
 slash		\/
 

--Qxx1br4bt0+wmkIi--
