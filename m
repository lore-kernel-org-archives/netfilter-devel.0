From: Eric Leblond <eric@regit.org>
Subject: [PATCH 0/4] build system improvements
Date: Sat,  3 Nov 2012 12:32:57 +0100
Message-ID: <1351942382-24791-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49002 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2KCMDU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:03:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small patchset containing some build system improvements.
The first three patches add a flag to disable the build of some
input plugins that depends on library. The last patch adds a message
at the end of configure run to indicate what will be build.

Patchset statistic:
 configure.ac              |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 input/flow/Makefile.am    |    2 ++
 input/packet/Makefile.am  |    4 ++++
 input/sum/Makefile.am     |    4 ++--
 output/ulogd_output_XML.c |    7 ++++++-
 5 files changed, 75 insertions(+), 8 deletions(-)

BR,
--
Eric
