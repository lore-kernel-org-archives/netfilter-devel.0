From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3 nft] [RFC] more syntax changes
Date: Tue, 14 Jan 2014 12:30:27 +0100
Message-ID: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51896 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaANLaj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:30:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patchset contains more small syntax and evaluation changes
aiming to improve the interaction user <-> tool via most common shells:

* iifname and oifname mask matching: very simple approach to allow matching
  interface names via meta oifname and eth == eth.

* Rename typical binary operation so we don't need to escape them in
  bash: '&' by 'and', '|' by 'or' and '!' by 'not'. They are just a
  few character longers and the syntax still looks nice to me.

* Rename 'eth' by 'ether', to mimic tcpdump. This also skips problems with
  a valid and simple possible iifname/oifname mask.

Comments welcome. Thanks!

Pablo Neira Ayuso (3):
  scanner: replace binary characters '&' '|' and '!' by their names
  evaluate: allow to use string with binary operations
  scanner: rename address selector from 'eth' to 'ether'

 src/evaluate.c |    3 ++-
 src/parser.y   |    4 ++--
 src/scanner.l  |    8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

-- 
1.7.10.4

