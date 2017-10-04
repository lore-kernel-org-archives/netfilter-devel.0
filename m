From: Phil Sutter <phil@nwl.cc>
Subject: libnftables, next steps
Date: Thu, 5 Oct 2017 00:51:52 +0200
Message-ID: <20171004225152.GD32278@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53072 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdJDWvz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 18:51:55 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

I rebased Eric's libnftables patch series onto current master to get an
overview of what's still missing (and what I could work on :). Here's
what I collected:

* Implement application accessible batch support.
  -> This basically splits nft_run() into stages.
  -> I would change nft_run_cmd_from_*() to use this internally.
  -> Do we want this in the early library version or is this going to be
     part of the 'advanced API' to add later?

* Add erec_free_list().
  -> This becomes handy if the application wants to drop erec list
     without printing it (erec_print_list() clears the list while
     traversing it).
  -> No use for this if we only export nft_run_cmd_from_*() functions.

* Create src/nftables_common.c and include/nftables_common.h to hold
  nft_run() and nft_netlink().
  -> Is this meant as the (not exported) high-level library backend?
  -> If batch support is implemented, these could be removed after
     changing nft_run_cmd_from_*() and cli_complete() to use it.

* Move library routines from src/main.c into src/libnftables.c and
  create include/nftables/nftables.h to hold the signatures.

* Introduce the library (i.e., generate libnftables.so).

Some additional thoughts:

* Should we support different output streams for debug and/or error
  messages?

* Should we reuse src/erec.c for regular output as well? (This probably
  needs a 'print immediately' switch for monitor mode, though.)

Feedback highly appreciated, of course! Should I start with moving the
library stuff into libnftables.{c,h} so we get an impression of what the
API will look like?

Cheers, Phil
