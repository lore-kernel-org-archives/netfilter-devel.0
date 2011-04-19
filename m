From: kaber@trash.net
Subject: [PATCH 0/3] netfilter: netfilter update
Date: Tue, 19 Apr 2011 16:31:29 +0200
Message-ID: <1303223492-13549-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following is a small netfilter update for net-next, containing:

- a patch from Eric to remove some atomic ops in the *tables fastpath

- removal of an unnecessary ifdef from IPVS by Simon

- SCTP and UDPLITE support for ipset, from Jozsef

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Thanks!
