From: mathieu.poirier@linaro.org
Subject: [PATCH 0/1] Add quota capabilities to nfacct
Date: Wed, 11 Dec 2013 09:53:17 -0700
Message-ID: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org, jpa@google.com, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38824 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LKQx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:53:28 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so10345360pbc.38
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2013 08:53:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Good day,

This patch adds the possibility of setting a packet or byte quota
to a nfacct object.  The feature follows the same logic as xtables
addons' xt_quota2 module.

For examble, to prevent sending more than 1000 icmp packets one would 
write:

iptables -I OUTPUT -p icmp -m nfacct --nfacct-name icmp-limit --packets ! --quota 1000 --jump REJECT

Of course, this implies that nfacct object 'icmp-limit' has been created using the nfacct utility.

Enhancement to iptables can be found here:
https://git.linaro.org/people/mathieu.poirier/iptables.git/commitdiff/deaf71950eec74d3ad596d1d744247e58c542c67?hp=76e230e41947576efb96e86e605bb84015cdb287

Best regards,
Mathieu

Mathieu Poirier (1):
  netfilter: xtables: add quota support to nfacct

 include/linux/netfilter/nfnetlink_acct.h      |  4 ++
 include/uapi/linux/netfilter/nfnetlink.h      |  2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |  1 +
 include/uapi/linux/netfilter/xt_nfacct.h      | 11 +++++
 net/netfilter/Kconfig                         |  3 +-
 net/netfilter/nfnetlink_acct.c                | 15 ++++++-
 net/netfilter/xt_nfacct.c                     | 65 ++++++++++++++++++++++++++-
 7 files changed, 97 insertions(+), 4 deletions(-)

-- 
1.8.1.2

