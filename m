From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft 0/4] src: changes related to numgen and hash expressions
Date: Sat, 22 Oct 2016 23:33:41 +0200
Message-ID: <cover.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36435 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbcJVVdq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 17:33:46 -0400
Received: by mail-wm0-f67.google.com with SMTP id f193so3948991wmg.3
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2016 14:33:45 -0700 (PDT)
Received: from sonyv (72.red-88-15-56.dynamicip.rima-tde.net. [88.15.56.72])
        by smtp.gmail.com with ESMTPSA id f194sm3332449wmg.12.2016.10.22.14.33.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Oct 2016 14:33:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset provides several improvements for numgen and hash
expressions:

 - support of OFFSET attribute for numgen and hash expressions
 - makes SEED attribute optional and randomly generated
 - fix the TYPE attribute to be treated as a register

Laura Garcia Liebana (4):
  src: make hash seed attribute optional
  src: add offset attribute for hash expression
  src: add offset attribute for numgen expression
  netlink: fix linearize numgen type

 configure.ac                        | 14 +++++++++++++-
 include/expression.h                |  2 ++
 include/hash.h                      | 13 ++++++++++++-
 include/linux/netfilter/nf_tables.h |  4 ++++
 include/numgen.h                    |  3 ++-
 src/hash.c                          |  9 +++++++--
 src/netlink_delinearize.c           | 10 ++++++----
 src/netlink_linearize.c             |  4 +++-
 src/numgen.c                        | 10 ++++++++--
 src/parser_bison.y                  | 20 +++++++++++++++-----
 src/scanner.l                       |  1 +
 tests/py/ip/hash.t                  |  4 ++++
 tests/py/ip/numgen.t                |  1 +
 13 files changed, 78 insertions(+), 17 deletions(-)

-- 
2.9.3

