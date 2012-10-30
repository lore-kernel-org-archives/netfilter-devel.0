From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/2] Removing the use of VLAIS from netfilter
Date: Tue, 30 Oct 2012 14:42:52 -0400
Message-ID: <1351622574-18421-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58904 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2J3Smi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:42:38 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so412759iag.19
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Oct 2012 11:42:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). The LLVMLinux Project is working towards the ability o=
f
providing the Linux kernel developer the choice of using the Clang comp=
iler
toolchain. This is a part of a series of patches which remove the use o=
f VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget.=
 Other
patches to allow Clang to be used will follow.

Behan Webster (1):
  Helper macros used for replacing the use of VLAIS

Jan-Simon M=C3=B6ller (1):
  Remove VLAIS usage from netfilter

 include/linux/valign.h      |   87 +++++++++++++++++++++++++++++++++++=
++++++++
 net/netfilter/xt_repldata.h |   40 ++++++++++++--------
 2 files changed, 111 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/valign.h

--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
