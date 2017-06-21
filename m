From: Florian Westphal <fw@strlen.de>
Subject: [4.11.y netfilter] 4.11 iptables regression fix
Date: Wed, 21 Jun 2017 10:41:51 +0200
Message-ID: <20170621084151.GD28291@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57940 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752002AbdFUImp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 04:42:45 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

Please consider picking up

commit 324318f0248c31be8a08984146e7e4dd7cdd091d
Author: Willem de Bruijn <willemb@google.com>
netfilter: xtables: zero padding in data_to_user

After this, you will also need to pick

commit 751a9c763849f5859cb69ea44b0430d00672f637
Author: Willem de Bruijn <willemb@google.com>
netfilter: xtables: fix build failure from COMPAT_XT_ALIGN outside CONFIG_COMPAT

Both apply cleanly to 4.11.  Earlier kernels are not affected.

Without these two patches we fail to delete rules, e.g.

iptables -A INPUT -i lo -p icmp --icmp-type 1 -j ACCEPT
iptables -D INPUT -i lo -p icmp --icmp-type 1 -j ACCEPT

2nd command fails to delete the newly added rule.
