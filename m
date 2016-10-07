From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 0/8] iptables-translate: fix some bugs and add more translations to nft
Date: Fri,  7 Oct 2016 19:08:48 +0800
Message-ID: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59145 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751549AbcJGLKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patch set fixes some bugs related to translation:
  * libipt_realm: add a missing space
  * libxt_iprange: ip6tables translation's format is not correct
  * libxt_iprange & libxt_devgroup: handle the invert flag properly
  * libxt_ipcomp: add range support

Also add libxt_quota, libxt_DSCP, libxt_statistic translation to nft.
Note: we only support statistic's nth mode translation, because random
mode is not completely supported in nft.

Liping Zhang (8):
  extensions: libipt_realm: add a missing space in translation
  extensions: libxt_iprange: rename "ip saddr" to "ip6 saddr" in
    ip6tables-xlate
  extensions: libxt_iprange: handle the invert flag properly in
    translation
  extensions: libxt_devgroup: handle the invert flag properly in
    translation
  extensions: libxt_ipcomp: add range support in translation
  extensions: libxt_quota: add translation to nft
  extensions: libxt_DSCP: add translation to nft
  extensions: libxt_statistic: add translation to nft

 extensions/libipt_realm.c    |  2 +-
 extensions/libxt_DSCP.c      | 64 +++++++++++++++++++++++++++++++++++---------
 extensions/libxt_devgroup.c  |  5 ++--
 extensions/libxt_ipcomp.c    | 10 ++++---
 extensions/libxt_iprange.c   | 52 ++++++++++++++---------------------
 extensions/libxt_quota.c     | 12 +++++++++
 extensions/libxt_statistic.c | 21 +++++++++++++++
 7 files changed, 115 insertions(+), 51 deletions(-)

-- 
2.5.5


