From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 0/7] some memory leak fixes
Date: Tue, 11 Jul 2017 00:32:48 +0200
Message-ID: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41120 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754106AbdGJWdN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Here's a small patchset fixing some memory leaks in nftables. Most
of them have been found using ASAN.

There is still a problem in memory handling due to the max_errors
system that stack errors to avoid an exit on first error. The
consequence is that the bison parser is loosing track of its
internal stacks and can not call the destructors when there
is an error in the command.

If we do set max_errors to 1: 

 diff --git a/src/main.c b/src/main.c
 index 7fbf00a..183bd0e 100644
 --- a/src/main.c
 +++ b/src/main.c
 @@ -29,7 +29,7 @@
  #include <cli.h>
  
  static struct nft_ctx nft;
 -unsigned int max_errors = 10;
 +unsigned int max_errors = 1;
  #ifdef DEBUG
  unsigned int debug_level;
  #endif

Then there is no more memory leak in case of an invalid command
but we loose the display of multiple errors.

A possibleway to fix that would be to be able to set max_errors
via a configuration function. It would be set to 1 by default.
So users of libnftables will not experiment memleak but we
could keep the same behavior in nft by setting it to 10
explicetely.

BR,
--
Eric

