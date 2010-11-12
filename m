From: kaber@trash.net
Subject: [PATCH 0/2] netfilter: netfilter fixes
Date: Fri, 12 Nov 2010 16:19:30 +0100
Message-ID: <1289575172-7272-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

The following two patches fix some netfilter bugs:

- missing parentheses in NF_HOOK_COND, breaking error propagation for
  dropped packets. From Eric Paris.

- incorrect checking for overlapping fragments in IPv6 conntrack
  reassembly. From Shan Wei

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git

Thanks!
