From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 0/3] include: Remove datatype_register(), __init and
 __exit macros.
Date: Fri, 30 Jun 2017 14:54:27 +0530
Message-ID: <cover.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35206 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdF3JYe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 05:24:34 -0400
Received: by mail-pg0-f65.google.com with SMTP id f127so14795755pgc.2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 02:24:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset removes datatype_register() function, __init and __exit
macro definitions.

Varsha Rao (3):
  include: Remove datatype_register().
  include: Remove __init macro definition.
  include: Remove __exit macro definition.

 include/ct.h       |  3 +++
 include/datatype.h |  1 -
 include/exthdr.h   |  1 +
 include/fib.h      |  2 ++
 include/meta.h     |  7 ++++++-
 include/nftables.h | 18 ++++++++++++++++++
 include/proto.h    |  8 ++++++++
 include/rt.h       |  1 +
 include/utils.h    |  2 --
 src/ct.c           | 17 +++++------------
 src/datatype.c     | 29 +++++++++++++++++++++--------
 src/exthdr.c       |  7 +------
 src/fib.c          |  7 +------
 src/gmputil.c      |  2 +-
 src/main.c         | 26 ++++++++++++++++++++++++++
 src/meta.c         | 52 +++++++++-------------------------------------------
 src/netlink.c      |  4 ++--
 src/proto.c        | 24 ++++++------------------
 src/rt.c           | 11 +++--------
 src/xt.c           |  2 +-
 20 files changed, 115 insertions(+), 109 deletions(-)

-- 
2.9.4

