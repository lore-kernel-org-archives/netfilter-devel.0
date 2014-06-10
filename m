From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] fix nft -i command crashes when try to input
 multi line command
Date: Tue, 10 Jun 2014 17:21:37 +0200
Message-ID: <20140610152137.GA13251@localhost>
References: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
 <20140610105552.GA9228@localhost>
 <CAHSpA59UwPmKGqOV_qGAGnzX7D84akiNMc4XLYpioxCAp7XrEA@mail.gmail.com>
 <20140610112212.GA10526@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39985 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaFJPVt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:21:49 -0400
Content-Disposition: inline
In-Reply-To: <20140610112212.GA10526@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 01:22:12PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 10, 2014 at 04:35:09PM +0530, Guruswamy Basavaiah wrote:
> > Hello,
> >  Steps to reproduce.
> >  [root@localhost ~]# nft -i
> > nft> add table filter
> > nft> list table \
> > 
> > readline: readline_callback_read_char() called with no handler!
> > Aborted (core dumped)
> > [root@localhost ~]#
> 
> I see, thanks.
> 
> Perhaps we can do something similar to python, I'd suggest:
> 
> nft> list table \
> .... filter
> table ip filter {
>         chain INPUT {
>                 type filter hook input priority 0;
>         }
> }
> 
> I mean use "...." if we are in the context of a multiline.

In that direction, I took your patch and included that change into it.
Find it attached. If nobody rise the hand, I'll push it to master.

--BXVAT5kNtrzKuDFl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-cli-fix-nft-i-command-crashes-when-try-to-input-mult.patch"

>From b24ac2bfe6b6e4b0c1a5ac164369aafc61b75ed9 Mon Sep 17 00:00:00 2001
From: Guruswamy Basavaiah <guru2018@gmail.com>
Date: Sun, 8 Jun 2014 00:44:16 +0530
Subject: [PATCH] cli: fix nft -i command crashes when try to input multi line
 command

When try to input multiline command in "nft -i", it crashes.

Issue is, function cli_append_multiline() return null in case of
multiline command. But in the calling function cli_complete(),
cli_exit is getting called, which in turn calls
rl_callback_handler_remove() and the handler is getting removed.

 [root@localhost ~]# nft -i
 nft> add table filter
 nft> list table \

 readline: readline_callback_read_char() called with no handler!
 Aborted (core dumped)
 [root@localhost ~]#

After this patch, it shows:

 nft> list table \
 .... filter
 table ip filter {
 }
 nft>

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/cli.c b/src/cli.c
index 8875207..f748a0e 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -66,6 +66,7 @@ static char *cli_append_multiline(char *line)
 		multiline = line;
 		rl_save_prompt();
 		rl_clear_message();
+		rl_set_prompt(".... ");
 	} else {
 		len += strlen(multiline);
 		s = xmalloc(len + 1);
@@ -89,13 +90,16 @@ static void cli_complete(char *line)
 	const char *c;
 	LIST_HEAD(msgs);
 
-	line = cli_append_multiline(line);
 	if (line == NULL) {
 		printf("\n");
 		cli_exit();
-		return;
+		exit(0);
 	}
 
+	line = cli_append_multiline(line);
+	if (line == NULL)
+		return;
+
 	for (c = line; *c != '\0'; c++)
 		if (!isspace(*c))
 			break;
-- 
1.7.10.4


--BXVAT5kNtrzKuDFl--
