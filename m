From: Jan Engelhardt <jengelh@medozas.de>
Subject: pull: minor tidbits
Date: Tue, 26 May 2009 13:26:22 +0200
Message-ID: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34621 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEZL03 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Please pull from
	git://dev.medozas.de/iptables master

to receive non-API-touching minor cosmetics and a few fixes
to recently-reported issues:

	xtables: use extern "C"
	extensions: add const qualifiers in print/save functions
	iptables: replace open-coded sizeof by ARRAY_SIZE
	addrtype: fix one manpage type
	manpages: do not include v4-only modules in ip6tables manpage


thanks,
Jan
