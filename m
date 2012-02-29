From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_cttimeout: misc cleanup
Date: Wed, 29 Feb 2012 08:15:36 +0100
Message-ID: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48527 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966125Ab2B2HPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Note that src/*.c reads "GPL-2.0+" while the COPYING file shows
an LGPL-2.1 text. Clarification would be welcome.

===
The following changes since commit eb9385b594bbd463fdc0704c33ca88e4d2e4cbb1:

  add README file (2012-02-29 03:33:44 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_cttimeout master

Jan Engelhardt (6):
      Add .gitignore
      const-ify static data objects
      Add stdint header and type corrections
      Properly NUL-terminate name in nfct_timeout_attr_set
      const-ify arguments of functions
      Add extern "C" guard for C++ compilation mode

 .gitignore                                         |   18 +++++++++++
 .../libnetfilter_cttimeout.h                       |   13 ++++++-
 src/libnetfilter_cttimeout.c                       |   33 +++++++++++---------
 3 files changed, 47 insertions(+), 17 deletions(-)
 create mode 100644 .gitignore
