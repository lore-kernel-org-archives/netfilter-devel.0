From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 00/14] cache consolidation
Date: Mon, 10 Aug 2015 13:50:34 +0200
Message-ID: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbHJLov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:44:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is another round of the patchset to consolidate the nft cache:

http://marc.info/?l=netfilter-devel&m=143620630223923&w=2

The idea consists of creating a cache of tables that is populated with chains,
rules, sets and elements.

The major change in this round is the fact that the cache is built later on
from the evaluation step where we have more context on what is going on. At
that stage, we know if this is a listing, in that case nft populates a full
blown cache. Otherwise, it only retrieves the table and set objects which is
the bare minimum that we require at this stage (at least by now). With the
previous patchset, with inconditional full blown cache retrieval, I noticed a
slowdown when working with large rulesets, so this new round patchset round
addresses this.

In the interactive mode, this cache is refreshed for every command to make sure
that we work with a ruleset that is current. We can avoid this by checking for
the generation counter, but will be looking into how to speed up this with
follow up patches when this is in master.

Comments welcome. Thanks.

Pablo Neira Ayuso (14):
  src: add cache infrastructure and use it for table objects
  src: add cmd_evaluate_list()
  rule: add reference counter to the table object
  src: add table declaration to cache
  src: use cache infrastructure for set objects
  src: add set declaration to cache
  src: early allocation of the set ID
  rule: add chain reference counter
  src: use cache infrastructure for chain objects
  evaluate: add cmd_evaluate_rename()
  src: add chain declarations to cache
  src: use cache infrastructure for rule objects
  src: use cache infrastructure for set element objects
  src: get rid of EINTR handling for nft_netlink()

 include/rule.h |    9 ++
 src/cli.c      |    1 +
 src/evaluate.c |  146 +++++++++++++++++-------
 src/main.c     |    7 +-
 src/netlink.c  |    4 -
 src/rule.c     |  337 ++++++++++++++++++++++++++++++++------------------------
 6 files changed, 310 insertions(+), 194 deletions(-)

-- 
1.7.10.4

