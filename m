From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] ct: use nftables sysconf location for connlabel
 configuration
Date: Wed, 20 Jul 2016 18:19:17 +0200
Message-ID: <20160720161917.GA1413@salvia>
References: <1469009825-1188-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbcGTQTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 12:19:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BBBB6392E01
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:19:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ACD5C9EBB7
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:19:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 78838FC61C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:19:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469009825-1188-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 20, 2016 at 12:17:05PM +0200, Florian Westphal wrote:
> Instead of using /etc/xtables use the nftables syconfdir.
> Also update error message to tell which label failed translation
> and which config file was used for this:
> 
> nft add filter input ct label foo
> <cmdline>:1:27-29: Error: /etc/nftables/connlabel.conf: could not parse conntrack label "foo"
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/Makefile.am | 2 ++
>  src/ct.c        | 7 +++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 8c59449..ff1dd6e 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -27,6 +27,8 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
>  
>  BUILT_SOURCES = parser_bison.h
>  
> +ct.o: AM_CFLAGS += -DCONNLABEL_PATH="\"${sysconfdir}/\""

I think we can simplify this by using DEFAULT_INCLUDE_PATH.

See patch attached, it applies on top of this one. Feel free to
collapse them.

--oyUTqETQ0mS9luUI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/Makefile.am b/src/Makefile.am
index ff1dd6e..8c59449 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -27,8 +27,6 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
 
 BUILT_SOURCES = parser_bison.h
 
-ct.o: AM_CFLAGS += -DCONNLABEL_PATH="\"${sysconfdir}/\""
-
 nft_SOURCES =	main.c				\
 		rule.c				\
 		statement.c			\
diff --git a/src/ct.c b/src/ct.c
index e974307..f383f29 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -29,7 +29,7 @@
 #include <utils.h>
 #include <statement.h>
 
-#define CONNLABEL_CONF	CONNLABEL_PATH "connlabel.conf"
+#define CONNLABEL_CONF	DEFAULT_INCLUDE_PATH "connlabel.conf"
 
 static const struct symbol_table ct_state_tbl = {
 	.symbols	= {
@@ -130,8 +130,8 @@ static struct error_record *ct_label_type_parse(const struct expr *sym,
 
 	dtype = sym->dtype;
 	if (s->identifier == NULL)
-		return error(&sym->location, "%s: could not parse %s \"%s\"", CONNLABEL_CONF,
-			     dtype->desc, sym->identifier);
+		return error(&sym->location, "%s: could not parse %s \"%s\"",
+			     CONNLABEL_CONF, dtype->desc, sym->identifier);
 
 	if (s->value >= CT_LABEL_BIT_SIZE)
 		return error(&sym->location, "%s: out of range (%u max)",

--oyUTqETQ0mS9luUI--
