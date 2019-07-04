Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200EEC06513
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E75B22082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGDMlm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 08:41:42 -0400
Received: from mail.us.es ([193.147.175.20]:49410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfGDMlm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 08:41:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65E66C32D7
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 14:41:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52D356D2AC
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 14:41:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47F71DA4D1; Thu,  4 Jul 2019 14:41:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E03B4FA28;
        Thu,  4 Jul 2019 14:41:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Jul 2019 14:41:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EDEF04265A32;
        Thu,  4 Jul 2019 14:41:36 +0200 (CEST)
Date:   Thu, 4 Jul 2019 14:41:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 1/3] nft: don't use xzalloc()
Message-ID: <20190704124136.2go4aouj2l4vva6i@salvia>
References: <156197834773.14440.15033673835278456059.stgit@endurance>
 <20190704102123.GA20778@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5e44achjnzqnzqa4"
Content-Disposition: inline
In-Reply-To: <20190704102123.GA20778@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5e44achjnzqnzqa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2019 at 12:21:23PM +0200, Phil Sutter wrote:
> Hi Arturo,
> 
> On Mon, Jul 01, 2019 at 12:52:48PM +0200, Arturo Borrero Gonzalez wrote:
> > In the current setup, nft (the frontend object) is using the xzalloc() function
> > from libnftables, which does not makes sense, as this is typically an internal
> > helper function.
> > 
> > In order to don't use this public libnftables symbol (a later patch just
> > removes it), let's use calloc() directly in the nft frontend.
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> 
> This series breaks builds for me. Seems you missed xfree() and xmalloc()
> used in src/main.c and src/cli.c.

Hm, this did not break here for me.

Patch is attached.

--5e44achjnzqnzqa4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-use-malloc-and-free-from-cli-and-main.patch"

From e4e5d4a4bd460194c330848cde1e0e96cdba9ce9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 4 Jul 2019 14:38:37 +0200
Subject: [PATCH nft] src: use malloc() and free() from cli and main

xmalloc() and xfree() are internal symbols of the library, do not use
them.

Fixes: 16543a0136c0 ("libnftables: export public symbols only")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c  | 9 ++++++---
 src/main.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/cli.c b/src/cli.c
index ca3869abe335..3015fdcb0b1f 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -63,9 +63,12 @@ static char *cli_append_multiline(char *line)
 		rl_set_prompt(".... ");
 	} else {
 		len += strlen(multiline);
-		s = xmalloc(len + 1);
+		s = malloc(len + 1);
+		if (!s)
+			return NULL;
+
 		snprintf(s, len + 1, "%s%s", multiline, line);
-		xfree(multiline);
+		free(multiline);
 		multiline = s;
 	}
 	line = NULL;
@@ -111,7 +114,7 @@ static void cli_complete(char *line)
 		add_history(line);
 
 	nft_run_cmd_from_buffer(cli_nft, line);
-	xfree(line);
+	free(line);
 }
 
 static char **cli_completion(const char *text, int start, int end)
diff --git a/src/main.c b/src/main.c
index 8e6c897cdd36..694611224d07 100644
--- a/src/main.c
+++ b/src/main.c
@@ -329,7 +329,7 @@ int main(int argc, char * const *argv)
 		exit(EXIT_FAILURE);
 	}
 
-	xfree(buf);
+	free(buf);
 	nft_ctx_free(nft);
 
 	return rc;
-- 
2.11.0


--5e44achjnzqnzqa4--
