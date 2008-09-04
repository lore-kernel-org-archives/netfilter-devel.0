From: Patrick McHardy <kaber@trash.net>
Subject: Re: 7/7 [NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard for extensions
Date: Thu, 04 Sep 2008 17:10:49 +0200
Message-ID: <48BFFA79.701@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131943180.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050300090604020603070806"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYIDPKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:10:52 -0400
In-Reply-To: <alpine.LNX.1.10.0808131943180.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050300090604020603070806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> [NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard for extensions
> 
> When a match or target is looked up using xt_find_{match,target},
> Xtables will also search the NFPROTO_UNSPEC module list. This allows
> for protocol-independent extensions (like xt_time) to be reused from
> other components (e.g. arptables, ebtables).
> 
> Extensions that take different codepaths depending on match->family
> or target->family of course cannot use NFPROTO_UNSPEC within the
> registration structure (e.g. xt_pkttype).

Nice work. You should have compile tested it though.

Applied.


--------------050300090604020603070806
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 9365a49..18d8884 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -81,7 +81,7 @@ static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
 
-static struct xt_match string_mt_reg[] __read_mostly = {
+static struct xt_match xt_string_mt_reg[] __read_mostly = {
 	{
 		.name 		= "string",
 		.revision	= 0,

--------------050300090604020603070806--
