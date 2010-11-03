From: kaber@trash.net
Subject: [PATCH 0/5] netfilter: netfilter fixes
Date: Wed,  3 Nov 2010 23:12:47 +0100
Message-ID: <1288822372-21245-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

the following five patches for 2.6.37-rc fix a few netfilter bugs:

- a lost __GFP_HIGHMEM from conntrack hashtable allocation, from Eric

- two unused function warnings in NAT without ctnetlink, from myself

- a missing memory barrier in conntrack protocol registration, from Eric

- two information leaks in arp_tables and ip_tables, from Vasiliy Kulikov

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git

Thanks!
