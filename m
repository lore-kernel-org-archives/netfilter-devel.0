From: mathieu.poirier@linaro.org
Subject: [PATCH RESEND v2 0/1] Add quota capabilities to nfacct
Date: Sun, 26 Jan 2014 13:04:32 -0700
Message-ID: <1390766673-21444-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Can I ask one of the maintainers to have a quick look at this please? 
The code is simple to understand and the mofications self contained.  
We missed the 3.14 merge window, it would be very disappointing to
miss the next one.

This is the second version of the feature rebased on the 3.13 kernel - all
comments from the maintainer have been followed except for the removal of
a spinlock that protects the integrity of an internal accounting structure.

I have sent a scenario for the output path that explains the concequence of
not having the structure guarded by said spinlock but received no answer.

As such I am sending this second version with all comments addressed less
the spinlock removal in the hope of getting more feedback on the matter.

Corresponding iptables modifications can be found here:
https://git.linaro.org/people/mathieu.poirier/iptables.git

Mathieu Poirier (1):
  netfilter: xtables: add quota support to nfacct

 include/linux/netfilter/nfnetlink_acct.h      |  11 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  14 ++++
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  35 ++++++---
 net/netfilter/xt_nfacct.c                     | 107 +++++++++++++++++++++++---
 7 files changed, 150 insertions(+), 23 deletions(-)

-- 
1.8.3.2

