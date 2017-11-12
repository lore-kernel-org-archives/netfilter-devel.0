From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 0/5] netfilter: exit_net checks for objects initialized in
 net_init hook
Date: Sun, 12 Nov 2017 14:32:14 +0300
Message-ID: <2f512ef8-8bb8-c227-1cde-1be56ae4c3ec@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:26406 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdKLLcX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:32:23 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OpenVz kernel team have a long history of fighting against namespace-related bugs,
some of them could be excluded by using simple checks described below.

One of typical errors is related to live cycle of namespaces:
usually objects created for some namespace should not live longer than namespace itself.

Such kind of issues can be invisible on usual systems where additional namespaces
are not used, because initial namespaces usually lives forever and never destroyed.

However in systems with namespaces it can lead to memory leaks or to use-after-free.
Both of them are critical for systems with running containers.
As you knows it's quite hard to find the reason of such issues,
especially in rarely-triggered scenarios on production nodes on default kernels
without specially enabled debug settings. Any additional hints can be useful here.

This patch set should help to detect some of these issues.
It is based on assumption that objects initialized in init hook of pernet_operations
should return to initial state until end of exit hook.

Many drivers and subsystems already have such checks, however I've found number
of places where list_empty check would be useful at least as smoke test.

These checks are useful for long-term stable kernels,
they allows to detect problems related to incomplete or incorrectly
backported patches.

Changes:
v5:
- fixed nit pointed by Florian Westphal
- netfilter patches are send separately to netfilter-devel@

v4:
- excluded grace and lockd patches taken by Bruce Fields
- let's use WARN_ON_ONCE without any extra messages
   adobriyan@ is right, output of net Id gives nothing to host admin,
   and developers in any case will extract information from core dump
- updated description in cover letter
- dropped nfs4blocklayout patch: waitqueue check does not look useful
- patches was reordered to be per-subsystem grouped
- cover letter should be sent to all people included into cc: of any patches
- minor cosmetic changes in some patches

v3:
- use net->ns.inum as net Id
- removed patches for hashlimit and recent,
    they handle tables list in exit_net hook.
- added patches for grace and lockd

v2:
- net pointer removed from output
- fixed compilation for phonet driver

Vasily Averin (5):
  clusterip: exit_net cleanup check added
  nf_tables: exit_net cleanup check added
  nfnetlink_log: exit_net cleanup check added
  nfnetlink_gueue: exit_net cleanup check added
  x_tables: exit_net cleanup check added

 net/ipv4/netfilter/ipt_CLUSTERIP.c | 1 +
 net/netfilter/nf_tables_api.c      | 7 +++++++
 net/netfilter/nfnetlink_log.c      | 4 ++++
 net/netfilter/nfnetlink_queue.c    | 5 +++++
 net/netfilter/x_tables.c           | 9 +++++++++
 5 files changed, 26 insertions(+)

-- 
2.7.4

