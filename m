From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Netfilter bugzilla
Date: Mon, 29 Sep 2008 08:54:59 +0200
Message-ID: <48E07BC3.9020107@netfilter.org>
References: <09095012B8574F16A942F01268EA7D3D@pgreco>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090801000400020302070403"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: =?ISO-8859-1?Q?Pablo_Sebasti=E1n_Greco?= <pablo@fliagreco.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35103 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbYI2GzJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:55:09 -0400
In-Reply-To: <09095012B8574F16A942F01268EA7D3D@pgreco>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090801000400020302070403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Pablo,

Pablo Sebastián Greco wrote:
> Pablo, a few days ago, i filed bug
> http://bugzilla.netfilter.org/show_bug.cgi?id=556 , but I had a problem
> creating the attachment patch, and a message appeared saying that I
> should contact you about this.

Hm, without the specific error there's nothing I can do, I'll check this
anyway to try to guess what's wrong.

> OTOH, do you know what should I do to make this bug fixed?

I have applied the following  patch to the iptables git tree.

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=summary

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090801000400020302070403
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 8c8c1c8096570d94d13539c4928ddb3650642763
Author: Pablo Sebastian Greco <pablo@fliagreco.com.ar>
Date:   Mon Sep 29 08:47:39 2008 +0200

    mark: fix invalid iptables-save output
    
    When a neg mark is saved via iptables-save it is saved as !--mark,
    but this is not recognized by iptables-restore, just adding a space
    to the saved file to make it look like "! --mark" makes
    iptables-restore accept the file.
    
    Signed-off-by: Pablo Sebastian Greco <pablo@fliagreco.com.ar>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 811cc77..4ee29e7 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -125,7 +125,7 @@ static void mark_mt_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
 
 	if (info->invert)
-		printf("! ");
+		printf("!");
 
 	printf("--mark ");
 	print_mark(info->mark, info->mask);

--------------090801000400020302070403--
