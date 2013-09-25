From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 0/6] Add net namespace support for ipt_CLUSTERIP
Date: Wed, 25 Sep 2013 15:38:43 +0800
Message-ID: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab3IYHhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7be7b004283
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:41 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset adds net namespace support for ipt_CLUSTERIP,
makes clusterip_configs,clusterip_lock and clusterip_procdir
per net namespace, and allow users in container to operate
the proper pernet resource of CLUSTERIP.

Gao feng (6):
  ipt_CLUSTERIP: make proc directory per net namespace
  ipt_CLUSTERIP: make clusterip_list per net namespace
  ipt_CLUSTERIP: make clusterip_lock per net namespace
  ipt_CLUSTERIP: add parameter net in clusterip_config_find_get
  ipt_CLUSTERIP: create proc entry under proper ipt_CLUSTERIP directory
  ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP

 net/ipv4/netfilter/ipt_CLUSTERIP.c | 110 +++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 35 deletions(-)

-- 
1.8.3.1

