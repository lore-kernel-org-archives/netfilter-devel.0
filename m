From: mathieu.poirier@linaro.org
Subject: [PATCH v2 0/1] Add quota capabilities to nfacct
Date: Mon, 20 Jan 2014 07:55:37 -0700
Message-ID: <1390229738-20183-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org, jpa@google.com, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This is the second version of the feature - all comments from the maintainer
have been followed except for the removal of a spinlock that protects the
integrity of an internal accounting structure.

I have sent a scenario for the output path that explains the concequence of
not having the structure guarded by a spinlock but received no answer.

As such I am sending this second version with all comments addressed less
the spinlock removal in the hope of getting more feedback on the matter.

Corresponding iptables modifications can be found here:
https://git.linaro.org/people/mathieu.poirier/iptables.git

Mathieu Poirier (1):
  netfilter: xtables: add quota support to nfacct

 include/linux/netfilter/nfnetlink_acct.h      |  12 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  14 ++++
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  36 ++++++---
 net/netfilter/xt_nfacct.c                     | 109 +++++++++++++++++++++++---
 7 files changed, 152 insertions(+), 25 deletions(-)

-- 
1.8.3.2

