From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log 0/3] Misc code cleaning
Date: Mon, 29 Dec 2008 22:33:21 +0100
Message-ID: <1230586404-24639-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43340 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbYL2Vdb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:33:31 -0500
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1LHPjp-0006dc-1F
	for netfilter-devel@vger.kernel.org; Mon, 29 Dec 2008 22:33:25 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This small patchset cleans some part of the code of libnetfilter_log:
 * Suppress reference to libnetfilter_queue which is the model of libnetfilter_log.
 * Set nflog_errno as needed:
	some FIXME were remaining, this patch fix this issue
 * Suppress NFULNL_MSG_CONFIG callback registration:
	last FIXME was about a not coded and not used feature. The patch
	disables it.

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/

Patchset statistics:
 src/libnetfilter_log.c |   38 +++++++++-----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)


