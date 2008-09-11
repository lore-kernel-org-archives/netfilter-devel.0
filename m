From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/3] cleaning and build feature
Date: Thu, 11 Sep 2008 22:48:02 +0200
Message-ID: <1221166085-23435-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:47374 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbYIKUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:48:10 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This small patchset contains some cleaning and implement conditionnal compilation
of NFLOG and NFCT input plugins. This feature was contained in the TODO list and I
think it could be useful on system where one of the NFCT or NFLOG plugin can not
be used.


Las tpatch update the TODO list.  The remaining item in this TODO list are:
 - add support for capabilities to run as non-root: It could be interesting but
 I don't know if we could achieve it with libnetfilter_log or libnetfilter_conntrack.
 - support for static linking: As ulogd2 is plugin based, it may be strange but some
 embedded system could use it.
 - issues with ulogd_BASE and partially copied packets (--ulog-cprange): Has somebody
 encounter the problem ?
 - problem with ulogd_BASE and fragments:  same remark
 - port SQLITE3 plugin: Holger's work could be reused but the code was not really clean.
 - convert db layer and pgsql + mysql plugin to a 'parameter bind' scheme for efficiency:
 I don't understand the point.
 - autoconf detection of SCTP / DCCP support: Well, why not ;)

>From my point of view, there is no other thing in the TODO list before a RC release.

Am I missing something ?

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
