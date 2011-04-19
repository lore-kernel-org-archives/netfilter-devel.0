From: kaber@trash.net
Subject: [PATCH 0/3] netfilter: netfilter fixes for 2.6.39-rc4
Date: Tue, 19 Apr 2011 16:51:42 +0200
Message-ID: <1303224705-17400-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following are three netfilter fixes for 2.6.39-rc4, containing:

- a fix for the bitmap:ip,mac set type to require the src/dst parameter
  to be set to src, from Jozsef

- a fix to make --del-set of the SET target work, from Jozsef

- a patch to fix the order in which sets are dumped, from Jozsef

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Thanks!

