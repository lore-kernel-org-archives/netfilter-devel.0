From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/4] Misc cleaning
Date: Wed, 23 Jul 2008 13:33:51 +0200
Message-ID: <1216812835-9851-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43426 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751062AbYGWLd4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:33:56 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1KLcbT-0002a0-6T
	for netfilter-devel@vger.kernel.org; Wed, 23 Jul 2008 13:33:55 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This small patchset fixes some problems. The main issue is a fix of my previous
patch where I've made a stupid type on a function name.
To avoid this kind of error, I propose an other patch which adds
"-Wall -Wextra" to gcc options.

The main concern here is about IPFIX which is in really bad shape. I've fix
some major error in one of the patch but it remains untested for now and I
don't think it can work properly.

Patchset statistics:
 configure.in                 |    2 ++
 filter/ulogd_filter_IP2BIN.c |    2 +-
 output/ulogd_output_IPFIX.c  |   12 +++++++-----
 util/db.c                    |    2 +-
 4 files changed, 11 insertions(+), 7 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
