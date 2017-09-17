From: Shmulik Ladkani <shmulik@nsof.io>
Subject: [PATCH v2 0/2] xt_bpf: fix handling of pinned objects
Date: Sun, 17 Sep 2017 14:20:29 +0300
Message-ID: <20170917112031.8644-1-shmulik@nsof.io>
Cc: Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        shmulik@nsof.io, Rafael Buchbinder <rafi@rbk.ms>
To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:49166 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdIQLUo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Sep 2017 07:20:44 -0400
Received: by mail-wr0-f174.google.com with SMTP id u96so4336085wrb.6
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Sep 2017 04:20:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Rafael Buchbinder <rafi@rbk.ms>

From: Rafael Buchbinder <rafi@rbk.ms>

Following set of commits fixes xt_bpf extension to correctly handle
pinned eBPF programs.

The origin of the bug lies in the fact that xt_bpf_info_v1 structure
requires an open file descriptor to create an eBPF match. 
This file descriptor is checked on every replace. However, as this file
descriptor is valid only for the iptables invocation which loads the
eBPF for the first time, all subsequent iptables invocations fail in
bpf_mt_check (kernel) function.

See discussion in [1] for more details.

The following patches add a hook in extensions which is called
immediately after TC_INIT to fixup whatever needs to be fixed up.
In case of xt_bpf, the fixup function gets the eBPF object by path to
populate xt_bpf_info_v1 structure with a valid file descriptor.

[1] https://marc.info/?l=netfilter-devel&m=150530909630143&w=2

Since v1:
  - fixed From field

Rafael Buchbinder (2):
  iptables: support match info fixup after tc_init
  extensions: xt_bpf: get the pinned ebpf object when match is
    initialized

 extensions/libxt_bpf.c |  9 +++++++++
 include/xtables.h      |  3 +++
 iptables/ip6tables.c   | 35 +++++++++++++++++++++++++++++++++++
 iptables/iptables.c    | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+)

-- 
2.14.1

