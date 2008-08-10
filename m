From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rfc: reject use of drop in nat table
Date: Sun, 10 Aug 2008 10:44:53 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808101044110.1727@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr> <489734F1.8040808@trash.net> <Pine.LNX.4.64.0808042050300.7375@blackhole.kfki.hu> <4897539C.1080102@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57985 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYHJOoy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Aug 2008 10:44:54 -0400
In-Reply-To: <4897539C.1080102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-08-04 15:08, Patrick McHardy wrote:
>> 
>> Instead of the line
>> 
>> +                       exit_error(OTHER_PROBLEM, "The nat table is not for
>> filtering");
>> 
>> the next one would probably be little bit more user friendly:
>> 
>> +                       fprintf(stderr, "The nat table is not for filtering,
>> next iptables release won't support it at all. Fix your setup.\n");
>> 
>> And in the next release it could be changed to 'exit_error'.
>
> That sounds good, lets do that.
>

commit 4241918dec00067d74cb3c8345efc8dcd08330e9
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 3 19:06:22 2008 +0200

Reject use of DROP in nat table

Consensus is that we should warn for now.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/iptables.c b/iptables.c
index 41e1836..6a105f8 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1917,6 +1917,14 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 		invert = FALSE;
 	}
 
+	if (strcmp(*table, "nat") == 0 &&
+	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
+	    (jumpto != NULL && strcmp(jumpto, "DROP") == 0)))
+		fprintf(stderr, "\nThe \"nat\" table is not intended for "
+		        "filtering, hence the use of DROP is deprecated and "
+		        "will permanently be disabled in the next iptables "
+		        "release. Please adjust your scripts.\n\n");
+
 	for (matchp = matches; matchp; matchp = matchp->next)
 		if (matchp->match->final_check != NULL)
 			matchp->match->final_check(matchp->match->mflags);
