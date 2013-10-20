From: Jan Engelhardt <jengelh@inai.de>
Subject: libnftables: build fixes
Date: Sun, 20 Oct 2013 16:29:14 +0200
Message-ID: <1382279356-5050-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38890 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab3JTO3V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:29:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit ec4b60bebcab23d46aa09bed06018457c35e5afa:

  src: json: remove spaces (2013-10-17 10:03:37 +0200)

are available in the git repository at:

  git://git.inai.de/libnftables master

for you to fetch changes up to 2952864a0bd3b074c322862fd4dbc792fb620818:

  build: resolve build errors in dependent programs (2013-10-20 16:28:55 +0200)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: resolve automake 1.12 warning
      build: resolve build errors in dependent programs

 configure.ac                  |  1 +
 include/libnftables/chain.h   | 10 ++++++++--
 include/libnftables/expr.h    | 10 ++++++++--
 include/libnftables/rule.h    | 10 ++++++++--
 include/libnftables/ruleset.h |  8 ++++++++
 include/libnftables/set.h     | 10 ++++++++--
 include/libnftables/table.h   | 10 ++++++++--
 7 files changed, 49 insertions(+), 10 deletions(-)
