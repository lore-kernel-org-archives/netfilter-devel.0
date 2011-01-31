From: kaber@trash.net
Subject: [PATCH 0/7] netfilter: netfilter update for -next
Date: Mon, 31 Jan 2011 21:10:13 +0100
Message-ID: <1296504620-820-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

following is a small netfilter update for net-next, containing:

- compiler warning fixes for IPVS from Changli

- IPVS netns fixes from Simon and Hans Schillstrom

- a fix for connlimit destination address selection in NAT scenarios,
  from Jan

- minor iprange bugfixes and debugging improvements from Thomas Jacob

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Thanks!
