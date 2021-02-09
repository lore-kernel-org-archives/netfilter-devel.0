Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7A9C433E9
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63F3A64EE4
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBIN6J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhBIN5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 08:57:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E2C061786;
        Tue,  9 Feb 2021 05:56:29 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l9TVB-0005Xq-QL; Tue, 09 Feb 2021 14:56:25 +0100
Date:   Tue, 9 Feb 2021 14:56:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210209135625.GN3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <20210208171444.GH16570@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Feb 08, 2021 at 06:14:44PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > In general, shells eating the quotes is problematic and users may not be
> > aware of it. This includes scripts that mangle ruleset dumps by
> > accident, etc. (Not sure if it is really a problem as we quote some
> > strings already).
> > 
> > Using JSON, there are no such limits, BTW. I really wonder if there's
> > really no fix for bison parser to make it "context aware".
> 
> Right.  We can probably make lots of keywords available for table/chain names
> by only recognizing them while parsing rules, i.e. via 'start conditions'
> in flex.  But I don't think there is anyone with the time to do the
> needed scanner changes.

Oh, I wasn't aware of start conditions at all, thanks for the pointer.
Instead of reducing most keyword's scope to rule context, I tried a less
intrusive approach, namely recognizing "only strings plus some extra" in
certain conditions. See attached patch for reference. With it in place,
I was at least able to:

# nft add table inet table
# nft add chain inet table chain
# nft add rule inet table chain iifname rule

Cheers, Phil

--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nftables_start_condition.diff"

diff --git a/src/scanner.l b/src/scanner.l
index 8bde1fbe912d8..c873cb7c1d226 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -107,6 +107,8 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 extern int	yyget_column(yyscan_t);
 extern void	yyset_column(int, yyscan_t);
 
+static int nspec;
+
 %}
 
 space		[ ]
@@ -194,6 +196,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option nodefault
 %option warn
 
+%x spec
+
 %%
 
 "=="			{ return EQ; }
@@ -250,19 +254,19 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hook"			{ return HOOK; }
 "device"		{ return DEVICE; }
 "devices"		{ return DEVICES; }
-"table"			{ return TABLE; }
+"table"			{ BEGIN(spec); nspec = 1; return TABLE; }
 "tables"		{ return TABLES; }
-"chain"			{ return CHAIN; }
+"chain"			{ BEGIN(spec); nspec = 2; return CHAIN; }
 "chains"		{ return CHAINS; }
-"rule"			{ return RULE; }
+"rule"			{ BEGIN(spec); nspec = 2; return RULE; }
 "rules"			{ return RULES; }
 "sets"			{ return SETS; }
-"set"			{ return SET; }
+"set"			{ BEGIN(spec); nspec = 2; return SET; }
 "element"		{ return ELEMENT; }
-"map"			{ return MAP; }
+"map"			{ BEGIN(spec); nspec = 2; return MAP; }
 "maps"			{ return MAPS; }
 "flowtable"		{ return FLOWTABLE; }
-"handle"		{ return HANDLE; }
+<*>"handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
 "trace"			{ return TRACE; }
 
@@ -280,8 +284,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "return"		{ return RETURN; }
 "to"			{ return TO; }
 
-"inet"			{ return INET; }
-"netdev"		{ return NETDEV; }
+<*>"inet"		{ return INET; }
+<*>"netdev"		{ return NETDEV; }
 
 "add"			{ return ADD; }
 "replace"		{ return REPLACE; }
@@ -380,7 +384,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
 
-"bridge"		{ return BRIDGE; }
+<*>"bridge"		{ return BRIDGE; }
 
 "ether"			{ return ETHER; }
 "saddr"			{ return SADDR; }
@@ -400,7 +404,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "plen"			{ return PLEN; }
 "operation"		{ return OPERATION; }
 
-"ip"			{ return IP; }
+<*>"ip"			{ return IP; }
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
 "dscp"			{ return DSCP; }
@@ -451,7 +455,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "igmp"			{ return IGMP; }
 "mrt"			{ return MRT; }
 
-"ip6"			{ return IP6; }
+<*>"ip6"		{ return IP6; }
 "priority"		{ return PRIORITY; }
 "flowlabel"		{ return FLOWLABEL; }
 "nexthdr"		{ return NEXTHDR; }
@@ -512,10 +516,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "meta"			{ return META; }
 "mark"			{ return MARK; }
 "iif"			{ return IIF; }
-"iifname"		{ return IIFNAME; }
+"iifname"		{ BEGIN(spec); nspec = 1; return IIFNAME; }
 "iiftype"		{ return IIFTYPE; }
 "oif"			{ return OIF; }
-"oifname"		{ return OIFNAME; }
+"oifname"		{ BEGIN(spec); nspec = 1; return OIFNAME; }
 "oiftype"		{ return OIFTYPE; }
 "skuid"			{ return SKUID; }
 "skgid"			{ return SKGID; }
@@ -613,7 +617,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{numberstring}		{
+<*>{numberstring}	{
+				if (nspec && !--nspec)
+					BEGIN(0);
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
 				if (errno != 0) {
@@ -639,7 +645,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return ASTERISK_STRING;
 			}
 
-{string}		{
+<*>{string}		{
+				if (nspec && !--nspec)
+					BEGIN(0);
 				yylval->string = xstrdup(yytext);
 				return STRING;
 			}
@@ -648,23 +656,23 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
 
-{newline}		{
+<*>{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 				return NEWLINE;
 			}
 
-{tab}+
-{space}+
-{comment}
+<*>{tab}+
+<*>{space}+
+<*>{comment}
 
-<<EOF>> 		{
+<*><<EOF>> 		{
 				update_pos(yyget_extra(yyscanner), yylloc, 1);
 				scanner_pop_buffer(yyscanner);
 				if (YY_CURRENT_BUFFER == NULL)
 					return TOKEN_EOF;
 			}
 
-.			{ return JUNK; }
+<*>.			{ return JUNK; }
 
 %%
 

--dc+cDN39EJAMEtIO--
