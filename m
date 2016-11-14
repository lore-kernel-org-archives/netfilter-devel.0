From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/3] src: add nft log flags support
Date: Mon, 14 Nov 2016 23:21:56 +0100
Message-ID: <20161114222156.GA28139@salvia>
References: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932946AbcKNWWG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 17:22:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BF93209429
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:22:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 325B2DA851
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:22:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 945D2DA849
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:22:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 25, 2016 at 05:06:58PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After NF_LOG_XXX is exposed to the userspace, we can set log flags to
> log more things. The following iptables rule:
>   # iptables -A OUTPUT -j LOG --log-tcp-sequence --log-tcp-options \
>   --log-ip-options --log-uid --log-macdecode
> is equal to the following nft rule:
>   # nft add rule filter OUTPUT log tcpseq,tcpopt,ipopt,uid,macdecode

Sorry, I wanted to have a closer look at this but time has been
running up and I didn't manage to get back to this.

So basically, I would like to explore different syntax for this, eg.

        log flags tcp sequence,options
        log flags ip options
        log flags skuid
        log flags ether

I think syntax would be larger, but it would look more consistent to
what we have. Worst case is to get them all set. We can provide a
compact version for this:

        log flags all

Please, see sketch patch attached for brainstorming.

Would you have a look into this? Thanks and again sorry for not
getting any sooner on this.

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 91955c187f3f..286290341ffb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -201,6 +201,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token EXPORT			"export"
 %token MONITOR			"monitor"
 
+%token ALL			"all"
+
 %token ACCEPT			"accept"
 %token DROP			"drop"
 %token CONTINUE			"continue"
@@ -268,6 +270,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token GATEWAY			"gateway"
 %token MTU			"mtu"
 
+%token OPTIONS			"options"
+
 %token IP6			"ip6"
 %token PRIORITY			"priority"
 %token FLOWLABEL		"flowlabel"
@@ -1530,6 +1534,25 @@ log_arg			:	PREFIX			string
 				$<stmt>0->log.level	= $2;
 				$<stmt>0->log.flags 	|= STMT_LOG_LEVEL;
 			}
+			|	FLAGS			log_flags
+			{
+				;
+			}
+			;
+
+log_flags		:	TCP	log_flags_tcp
+			|	IP	OPTIONS
+			|	SKUID
+			|	ETHER
+			|	ALL
+			;
+
+log_flags_tcp		:	log_flags_tcp	COMMA	log_flag_tcp
+			|	log_flag_tcp
+			;
+
+log_flag_tcp		:	SEQUENCE
+			|	OPTIONS
 			;
 
 level_type		:	string
diff --git a/src/scanner.l b/src/scanner.l
index cd7398b4e534..625023f5257c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -469,6 +469,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "notrack"		{ return NOTRACK; }
 
+"options"		{ return OPTIONS; }
+"all"			{ return ALL; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 

--ikeVEW9yuYc//A+q--
