From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_queue 0/4] misc code cleaning and documentation
Date: Fri, 19 Dec 2008 22:36:27 +0100
Message-ID: <1229722591-7836-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57384 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751460AbYLSVge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:34 -0500
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1LDn1L-0002OA-Fu
	for netfilter-devel@vger.kernel.org; Fri, 19 Dec 2008 22:36:31 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This small patchset fixes two inconsistencies:
 * Change variable name to have an homogeneous naming
 * Use nfq_fd function instead of call to nfnetlink function.
It also fixes a potential problem in nfq_close() where a ressource was freed twice:
 * Suppress double call of nfnl_subsys_close()
Last patch is a documentation update:
 * Switch documentation style to doxygen.
I've switched the documentation style to doxygen format. It is standard, easy
to use and very powerful. An html output example is available here:
	http://www.nufw.org/doc/libnetfilter_queue/

Patchset statistics:
 src/libnetfilter_queue.c |  437 ++++++++++++++++++++++++++++++++--------------
 utils/nfqnl_test.c       |    3 +-
 2 files changed, 310 insertions(+), 130 deletions(-)

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
