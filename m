From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/5] ipset: Extend netmask support for userspace
Date: Tue, 21 Mar 2017 14:39:52 -0400
Message-ID: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([23.79.238.175]:36181 "EHLO
        prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933473AbdCUSus (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:50:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These are the userspace changes to add the ability to specify a netmask
or wildcard mask for the set during creation instead of just a cidr
value.

Example usage:

Legacy behavior:
ipset create foo hash:ip family inet6 netmask 64

New netmask support (equivalent to legacy example):
ipset create foo hash:ip family inet6 netmask ffff:ffff:ffff:ffff::

New wildcard mask support:
ipset create foo hash:ip family inet6 netmask ffff:ffff:ffff:0:0:ffff:ffff:ffff

The 3 mask types are supported for ipv4 sets as well.

Josh Hunt (5):
  ipset: netmask: expand to support cidr and full mask
  ipset: hash:ip: add support for new netmask types
  ipset: hash:ipport: netmask support
  hash:ip: add new netmask support to man page
  hash:ip,port: add netmask support to man page

 include/libipset/data.h         |   5 +-
 include/libipset/linux_ip_set.h |   5 ++
 include/libipset/print.h        |   3 +
 lib/data.c                      |  25 +++++-
 lib/debug.c                     |   1 +
 lib/ipset_hash_ip.c             | 166 ++++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipport.c         | 194 ++++++++++++++++++++++++++++++++++++++++
 lib/parse.c                     |  68 ++++++++++++--
 lib/print.c                     |  39 +++++++-
 lib/session.c                   |   8 ++
 src/ipset.8                     |  90 +++++++++++++++++--
 11 files changed, 583 insertions(+), 21 deletions(-)

-- 
1.9.1

