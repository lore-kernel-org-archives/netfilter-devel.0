From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC][PATCH] nftables: add slash to chain syntax
Date: Sat, 30 Nov 2013 15:22:48 -0800
Message-ID: <20131130232248.GA23209@home>
References: <20131130232022.GA23206@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47903 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3XWv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 18:22:51 -0500
Received: by mail-pb0-f43.google.com with SMTP id rq2so16449543pbb.16
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Nov 2013 15:22:51 -0800 (PST)
Received: from home (cpe-98-154-84-14.socal.res.rr.com. [98.154.84.14])
        by mx.google.com with ESMTPSA id xn12sm76990913pac.12.2013.11.30.15.22.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 30 Nov 2013 15:22:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131130232022.GA23206@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

<v2: attach the patch this time...>

The current syntax when handling chains seems counterintuitive to me.  I would
expect that "add chain" would have the name of the chain directly after the
keyword "chain".  But instead, the name of the table is there, with the chain
after.  I think a better syntax might be this:

        add chain <table>/<chain>

which seems clearer to me.  And it has the added benefit of following the
"everything is a file" paradigm.  Who knows - maybe someday we can add a sysfs
interface for nftables, and this will fit nicely within a tree:

        nftables
          tables
            chains
              rules

Thoughts?  Attached patch is a general proof of concept.

Phil


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-slash_chain

diff --git a/src/parser.y b/src/parser.y
index a49e5c2..5f6fed0 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -833,10 +833,10 @@ tables_spec		:	family_spec
 			}
 			;
 
-chain_spec		:	table_spec	identifier
+chain_spec		:	table_spec	SLASH	identifier
 			{
 				$$		= $1;
-				$$.chain	= $2;
+				$$.chain	= $3;
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..ba1dcdf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -111,7 +111,7 @@ decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
-string		({letter})({letter}|{digit}|[/\-_\.])*
+string		({letter})({letter}|{digit}|[\-_\.])*
 quotedstring	\"[^"]*\"
 comment		#.*$
 slash		\/

--IS0zKkzwUGydFO0o--
