From: Jan Engelhardt <jengelh@medozas.de>
Subject: mnl: getpagesize
Date: Mon, 20 Dec 2010 01:44:42 +0100
Message-ID: <1292805884-27782-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59272 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0LTAor (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:44:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Pablo,

here is a patch for a compile error about missing getpagesize.

I also have this now:
mystuff.c:36:7: error: variably modified =E2=80=98buf=E2=80=99 at file =
scope

This is due to

struct def {
	char buf[MNL_SOCKET_BUFFER_SIZE];
};

This worked before mnl started using getpagesize :-/



The following changes since commit 093044ed01a91541c46ba9cc987fae5e9071=
32b1:

  doc: add new website at netfilter.org to doxygen (2010-12-17 15:45:00=
 +0100)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (1):
      include: add missing unistd.h

 include/libmnl/libmnl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
