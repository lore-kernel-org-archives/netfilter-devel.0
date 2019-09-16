Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EE2C4CED0
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9E720665
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OPOY6RfT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfIPMmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:42:09 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44742 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfIPMmI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 08:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FFvujvdKKrRnbFjvR9KsXR46UOQKWyZbQ/0rtbhwILk=; b=OPOY6RfTQoml3TaxGqKyYM3cBZ
        MYAY0W9iElqn3KLHwHFMP7svEX7tnUOB/3qCMAeMUUbPimjw6XpB2v4ldDWVydbv4AaxgaRbHLQgc
        aAvmSL7Bq7sFEXNS4YzwmNTAsy7UsYrfvkPXlmxWXJjIjSnVNOvt+ksZAlohSb7vU59yo9s8ZR/4e
        e9P57EBVoABCFK0ET0FMiIQqMfdNFE04CEa1dK64qVch/6xYO3mEFqSGrRppCC7fXBJmC1FnBtA3J
        +1G/E4rFOLQcGZ+WwzQokUvgAdWULaip7cEdIIWGZRMerbFIp4t7aPllCCVb5Sh+OY+J3B0G1mILI
        SKJmynnw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i9qKS-0005OR-5T; Mon, 16 Sep 2019 13:42:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH RFC nftables 0/4] Add Linenoise support to the CLI.
Date:   Mon, 16 Sep 2019 13:41:59 +0100
Message-Id: <20190916124203.31380-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sebastian Priebe [0] requested Linenoise support for the CLI as an
alternative to Readline, so I thought I'd have a go at providing it.
Linenoise is a minimal, zero-config, BSD licensed, Readline replacement
used in Redis, MongoDB, and Android [1].

 0 - https://lore.kernel.org/netfilter-devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
 1 - https://github.com/antirez/linenoise/

The upstream repo doesn't contain the infrastructure for building or
installing libraries.  I've taken a look at how Redis and MongoDB handle
this, and they both include the upstream sources in their trees (MongoDB
actually uses a C++ fork, Linenoise NG [2]), so I've done the same.

 2 - https://github.com/arangodb/linenoise-ng

Initially, I added the Linenoise header to include/ and the source to
src/, but the compiler warning flags used by upstream differ from those
used by nftables, which meant that the compiler emitted warnings when
compiling the Linenoise source and I had to edit it to fix them.  Since
they were benign and editing the source would make it more complicated
to update from upstream in the future, I have, instead, chosen to put
everything in a separate linenoise/ directory with its own Makefile.am
and the same warning flags as upstream.

By default, the CLI continues to be build using Readline, but passing
`with-cli=linenoise` instead causes Linenoise to be used instead.

The first two patches do a bit of tidying; the third patch adds the
Linenoise sources; the last adds Linenoise support to the CLI.

Jeremy Sowden (4):
  configure: remove unused AC_SUBST macros.
  cli: remove unused declaration.
  cli: add upstream linenoise source.
  cli: add linenoise CLI implementation.

 Makefile.am                 |    7 +-
 configure.ac                |   20 +-
 include/cli.h               |    3 +-
 linenoise/.gitignore        |    6 +
 linenoise/LICENSE           |   25 +
 linenoise/Makefile.am       |   13 +
 linenoise/Makefile.upstream |    7 +
 linenoise/README.markdown   |  229 +++++++
 linenoise/example.c         |   74 +++
 linenoise/linenoise.c       | 1201 +++++++++++++++++++++++++++++++++++
 linenoise/linenoise.h       |   73 +++
 src/Makefile.am             |    6 +
 src/cli.c                   |   64 +-
 13 files changed, 1710 insertions(+), 18 deletions(-)
 create mode 100644 linenoise/.gitignore
 create mode 100644 linenoise/LICENSE
 create mode 100644 linenoise/Makefile.am
 create mode 100644 linenoise/Makefile.upstream
 create mode 100644 linenoise/README.markdown
 create mode 100644 linenoise/example.c
 create mode 100644 linenoise/linenoise.c
 create mode 100644 linenoise/linenoise.h

-- 
2.23.0

