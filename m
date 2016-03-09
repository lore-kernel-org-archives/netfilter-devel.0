From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: nft: Modified punctuation used in nft's show_help
Date: Wed, 9 Mar 2016 12:46:53 +0530
Message-ID: <56DFCDE5.90003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35260 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcCIHQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 02:16:36 -0500
Received: by mail-pa0-f49.google.com with SMTP id td3so5770891pab.2
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2016 23:16:36 -0800 (PST)
Received: from [10.11.40.64] ([14.139.254.36])
        by smtp.gmail.com with ESMTPSA id wx3sm9727694pab.25.2016.03.08.23.16.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 08 Mar 2016 23:16:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replaced '/' between shortopt and longopt with ',' , as used by other utilities.

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 src/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/main.c b/src/main.c
index 7bbcfc4..d643970 100644
--- a/src/main.c
+++ b/src/main.c
@@ -107,19 +107,19 @@ static void show_help(const char *name)
 "Usage: %s [ options ] [ cmds... ]\n"
 "\n"
 "Options:\n"
-"  -h/--help			Show this help\n"
-"  -v/--version			Show version information\n"
+"  -h, --help			Show this help\n"
+"  -v, --version			Show version information\n"
 "\n"
-"  -f/--file <filename>		Read input from <filename>\n"
-"  -i/--interactive		Read input from interactive CLI\n"
+"  -f, --file <filename>		Read input from <filename>\n"
+"  -i, --interactive		Read input from interactive CLI\n"
 "\n"
-"  -n/--numeric			When specified once, show network addresses numerically (default behaviour).\n"
+"  -n, --numeric			When specified once, show network addresses numerically (default behaviour).\n"
 "  				When specified twice, show Internet services,\n"
 "				user IDs and group IDs numerically.\n"
 "				When specified thrice, also show protocols numerically.\n"
 "  -N				Translate IP addresses to names.\n"
-"  -a/--handle			Output rule handle.\n"
-"  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
+"  -a, --handle			Output rule handle.\n"
+"  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 #endif
-- 
1.9.1
