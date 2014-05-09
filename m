From: "LIU, Kun" <liukun@act.buaa.edu.cn>
Subject: How to NAT with source MAC address recorded?
Date: Fri, 9 May 2014 09:34:44 +0800
Message-ID: <835012AB67A67C408EEFBCCCC906381E02BFC41394A1@mail.lab.act.buaa.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [219.239.227.113] ([219.239.227.113]:30381 "EHLO
	mail.act.buaa.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaEIBfo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 May 2014 21:35:44 -0400
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, all,
  Please consider a case like this, in the virtualization computing platform, there are two virtual machines with different MAC addresses but the same IP address, now I need to do NAT for both of them in a Linux host with iptables. To address this issue, I want to add 'source mac' into the NAT table, as the Linux host needs to know the exact target when the packets from Internet arrived.  Should I change something in the kernel module of netfilter? Thanks for helping me.


Best regards,
Kun Liu
