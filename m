From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH iptables 0/3] Fix build errors on Android
Date: Sat, 26 Oct 2013 11:50:30 -0700
Message-ID: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57399 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3JZSuo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:50:44 -0400
Received: by mail-pb0-f45.google.com with SMTP id ma3so1240462pbc.18
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2013 11:50:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The current head of tree is not buildable with Android NDK r9 due to
a few small incompatibilities.  This series attempts to address them.

Android normally bundles a version of iptables which has additional
deltas (xt_quota2 match, xt_IDLETIMER modifications) from mainline.
I will not address those here.

With my patches applied, this produces a usable ARM xtables-multi binary:

NDK=/opt/android-ndk-r9
export PATH=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin:$PATH
./autogen.sh
./configure --host=arm-linux-androideabi \
        --disable-shared --enable-static \
        CFLAGS="--sysroot=$NDK/platforms/android-8/arch-arm"
make

I retested x86 PC builds to make sure that nothing else broke.

Another way to handle the TCPOPTSTRIP issue is to add #ifndef's in
libxt_TCPOPTSTRIP.c for each missing constant, similar to how
TCPOPT_MD5SIG is currently done.  If this is preferred, let me know.


Kevin Cernekee (3):
  android: libiptc: Fix socklen_t type mismatch on Android
  android: Don't include conflicting headers
  android: build: Blacklist TCPOPTSTRIP on systems that lack TCPOPT_*

 configure.ac                         |    8 ++++++++
 include/libiptc/ipt_kernel_headers.h |    2 +-
 libiptc/libip4tc.c                   |    2 +-
 libiptc/libip6tc.c                   |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

-- 
1.7.9.5

