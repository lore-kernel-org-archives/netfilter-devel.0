From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: nat drop the icmp redirect packet
Date: Mon, 28 Nov 2011 09:12:43 +0800
Message-ID: <4ED2E00B.3000006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1K1BMe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:12:34 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id CFE7B17010C
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2011 09:12:31 +0800 (CST)
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id pAS1CVUc004913
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2011 09:12:31 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

In func nf_nat_icmp_reply_translation,the icmp packet will be droped when the nat is not finished.
pc A(whose gateway is C) send a icmp request to pc B.
When gw C receive this packet,it may return a icmp redirect packet to A.
BUT now,the icmp request packet has not go to POSTROUTING,So the nat is not finished.
Finally,the icmp redirect packet will be droped no matter the conn has nat or not.

of course,the icmp redirect packet will be correct handled when nat is finished.

Can somebody will give me some suggestion,
or should I just add a sysctl to let the user decide drop or receive this icmp redirect packet when nat is not finished?
