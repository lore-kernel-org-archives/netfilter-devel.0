From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: conntrack: netmask filtering support
Date: Tue, 13 Jan 2015 11:55:09 +0000
Message-ID: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([81.7.185.110]:45272 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbbAML5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:57:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

These patches adds support for network filtering, using the
pre-existing netmask options and adds CIDR notation as well.

 conntrack.8          |   9 +-
 include/linux_list.h |   8 +-
 src/conntrack.c      | 234 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 228 insertions(+), 23 deletions(-)

--=20
Best regards
Asbj=C3=B8rn Sloth T=C3=B8nnesen
Network Engineer
=46iberby ApS - AS42541

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
