From: Jan Engelhardt <jengelh@inai.de>
Subject: libnftables header includes fixups
Date: Mon, 28 Oct 2013 13:27:16 +0100
Message-ID: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34043 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab3J1M11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit d8aec16c2b73a3f7b5183ccbe25d0522bf2f4f3c:

  include: fix missing struct nlmsghdr without definition (2013-10-27 22:03:01 +0100)

are available in the git repository at:

  git://git.inai.de/libnftables master

for you to fetch changes up to ca1a38c6aa552df9723c40459b7daccf381e8cd9:

  build: use C++11 headers if available (2013-10-28 13:24:34 +0100)

----------------------------------------------------------------
Jan Engelhardt (4):
      build: resolve automake 1.12 warning
      build: resolve build errors in dependent programs
      build: avoid inclusion of stdbool.h in C++
      build: use C++11 headers if available

 configure.ac                  |  1 +
 include/libnftables/chain.h   | 11 +++++++++--
 include/libnftables/expr.h    | 11 +++++++++--
 include/libnftables/rule.h    | 11 +++++++++--
 include/libnftables/ruleset.h | 10 ++++++++++
 include/libnftables/set.h     | 11 +++++++++--
 include/libnftables/table.h   | 11 +++++++++--
 7 files changed, 56 insertions(+), 10 deletions(-)
