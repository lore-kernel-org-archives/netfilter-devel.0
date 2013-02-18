From: Eric Leblond <eric@regit.org>
Subject: [ulogd patch] small code cleaning
Date: Mon, 18 Feb 2013 09:37:41 +0100
Message-ID: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48535 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3BRIiZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small patchset that brings some code cleaning and aim
at improving usability of ulogd.

Patchset statistics:
 TODO                              |    7 -------
 include/ulogd/conffile.h          |    7 ++++---
 input/packet/ulogd_inppkt_NFLOG.c |    2 --
 output/ulogd_output_LOGEMU.c      |    5 +----
 src/conffile.c                    |   31 +++++++++++++++++++++++++++++--
 src/ulogd.c                       |   12 ++++++++++--
 6 files changed, 44 insertions(+), 20 deletions(-)

If everybody is happy with this patchset, I will pushed it to
git tree and prepare a release in the upcoming weeks.

BR,
--
Eric Leblond <eric@regit.org>
