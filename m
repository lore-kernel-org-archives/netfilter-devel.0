From: Guruswamy B <guru2018@gmail.com>
Subject: [nftables PATCH] fix nft -i command crashes when try to input multi
 line command
Date: Sun, 8 Jun 2014 00:44:16 +0530
Message-ID: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61572 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaFGTOR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2014 15:14:17 -0400
Received: by mail-pb0-f51.google.com with SMTP id ma3so3852092pbc.10
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Jun 2014 12:14:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
 When try to input multiline command in "nft -i", it crashes.

 Issue is, function "cli_append_multiline" return null in case of
multiline command,
 But in the calling function "cli_complete", cli_exit is getting
called, which in turn calls "rl_callback_handler_remove"  and the
handler is getting removed.


Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
---
---
 src/cli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/cli.c b/src/cli.c
index 8875207..c0051a5 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -66,6 +66,7 @@ static char *cli_append_multiline(char *line)
        multiline = line;
        rl_save_prompt();
        rl_clear_message();
+       rl_set_prompt(">");
    } else {
        len += strlen(multiline);
        s = xmalloc(len + 1);
@@ -89,12 +90,15 @@ static void cli_complete(char *line)
    const char *c;
    LIST_HEAD(msgs);

-   line = cli_append_multiline(line);
    if (line == NULL) {
        printf("\n");
        cli_exit();
-       return;
+       exit(0);
    }
+
+   line = cli_append_multiline(line);
+   if(line == NULL)
+       return;

    for (c = line; *c != '\0'; c++)
        if (!isspace(*c))
-- 
1.9.3
