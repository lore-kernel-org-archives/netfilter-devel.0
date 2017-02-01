From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 conntrack-tools] conntrackd: config: Free strdup()ed
 tokens
Date: Wed, 1 Feb 2017 18:03:57 +0100
Message-ID: <20170201170357.GA5052@salvia>
References: <20170127203847.10785-1-cernekee@chromium.org>
 <20170127203847.10785-2-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752902AbdBAREF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2017 12:04:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C90F518018F
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6D4DDA804
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7D9FDA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:03:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170127203847.10785-2-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2017 at 12:38:47PM -0800, Kevin Cernekee wrote:
> This frees T_IP, T_PATH_VAL, and T_STRING tokens.  They were being flagged
> by valgrind as memory leaks.

Thanks Kevin.

I think we can just remove the strdup() from the lexer, given that we
always copy these strings in the parser.

See patch attached.

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 0282534e7291..a378269491f1 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -141,9 +141,9 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 {is_off}		{ return T_OFF; }
 {integer}		{ yylval.val = atoi(yytext); return T_NUMBER; }
 {signed_integer}	{ yylval.val = atoi(yytext); return T_SIGNED_NUMBER; }
-{ip4}			{ yylval.string = strdup(yytext); return T_IP; }
-{ip6}			{ yylval.string = strdup(yytext); return T_IP; }
-{path}			{ yylval.string = strdup(yytext); return T_PATH_VAL; }
+{ip4}			{ yylval.string = yytext; return T_IP; }
+{ip6}			{ yylval.string = yytext; return T_IP; }
+{path}			{ yylval.string = yytext; return T_PATH_VAL; }
 {alarm}			{ return T_ALARM; }
 {persistent}		{ dlog(LOG_WARNING, "Now `persistent' mode "
 			       "is called `alarm'. Please, update "
@@ -155,7 +155,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 			       "your conntrackd.conf file.\n");
 			  return T_FTFW; }
 {notrack}		{ return T_NOTRACK; }
-{string}		{ yylval.string = strdup(yytext); return T_STRING; }
+{string}		{ yylval.string = yytext; return T_STRING; }
 
 {comment}	;
 {ws}		;

--Qxx1br4bt0+wmkIi--
