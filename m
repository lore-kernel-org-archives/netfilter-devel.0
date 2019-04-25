Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726BAC43219
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 14:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681C9206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 14:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfDYOFT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:05:19 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56042 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfDYOFS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 10:05:18 -0400
Received: from localhost ([::1]:40892 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJezz-0000VM-Sy; Thu, 25 Apr 2019 16:05:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Eric Garver <e@erig.me>, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH RFC 0/2] JSON schema for nftables.py
Date:   Thu, 25 Apr 2019 16:05:00 +0200
Message-Id: <20190425140502.22761-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an initial implementation of support for jsonschema in
nftables.py. The goal is to have a schema definition which may be used
by users as well as our testsuite to make sure any JSON we accept or
generate is valid.

The added schema.json in patch 1 is very minimal for now - I have a more
detailed version but it is not complete yet. Also it is quite large
already, so for the sake of reviews the small one serves better.

A few aspects of the implementation I'm unsure of:

Keeping the schema in a "pure" JSON file makes things a bit complex: It
has to be shipped as data file and loaded by the validator using
json.load(). OTOH the content may be fed into json_verify and my editor
provides nicer syntax highlighting. An alternative would be to name it
schema.py, prefix the content with 'nftschema = ' and simply import it
into nftables.py. I don't think inlining the content is a good option
simply due to how large the file will get once definitions for all
statements and expressions are in there.

Introducing that SchemaValidator class is not really required, either.
Though squeezing everything into json_validate() method felt clumsy.
Also I wanted to avoid the explicit schema loading mentioned above upon
each call to json_validate(), so having an instance of a validator class
seemed like how one is supposed to do things in an object-oriented
language.

Note that SchemaValidator imports jsonschema upon instantiation. This
may be a bad idea to begin with, but the intention is to not introduce a
hard dependency on jsonschema in nftables.py. Same argument holds for
conditional import of traceback module in nft-test.py, although
validator errors are practically useless without it.

Phil Sutter (2):
  py: Implement JSON validation in nftables module
  tests/py: Support JSON validation

 py/Makefile.am       |  2 +-
 py/nftables.py       | 30 ++++++++++++++++++++++++++++++
 py/schema.json       | 17 +++++++++++++++++
 py/setup.py          |  1 +
 tests/py/nft-test.py | 29 ++++++++++++++++++++++++++++-
 5 files changed, 77 insertions(+), 2 deletions(-)
 create mode 100644 py/schema.json

-- 
2.21.0

