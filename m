From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: nfct parameters
Date: Thu, 7 Apr 2016 11:31:56 +0200
Message-ID: <5706290C.7080000@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-1.mx.upcmail.net ([62.179.121.148]:22106 "EHLO
	vie01a-dmta-at02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbcDGJcA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:32:00 -0400
Received: from [172.31.216.44] (helo=vie01a-pemc-psmtp-pe02)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1ao6I9-0004sv-OZ
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 11:31:57 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good day,

while I'm writing bash completion code for conntrack-tools, I browsed 
through the source and found some things, that raised this questions for 
me (I'm no C developer, so limited here).

1: Are there three undocumented parameters?
namely: disable, default-get, default-set
At least there are functions that do something... not sure what exactly 
w/ the default-* cmds.

2: in src/nfct-extensions/timeout.c there is:

static void
nfct_cmd_timeout_usage(char *argv[])
{
     fprintf(stderr, "nfct v%s: Missing command\n"
             "%s <list|add|delete|get|flush|set> timeout "
             "[<parameters>, ...]\n", VERSION, argv[0]);
}

Where a 'set' command is printed. Which is another discrepancy?

If my reading is correct, please take this mail as a bug report.

Best regards,
Mart
