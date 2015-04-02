From: Peter Sagerson <psagers@ignorare.net>
Subject: ulogd2 memory bug?
Date: Thu, 2 Apr 2015 12:30:57 -0700
Message-ID: <5D463327-1046-49FF-B5F6-0F7496216B47@ignorare.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aspen.ignorare.net ([173.255.208.5]:56209 "EHLO
	aspen.ignorare.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbDBTjW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 15:39:22 -0400
Received: from [172.16.1.12] (unknown [162.246.92.110])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: psagers@ignorare.net)
	by aspen.ignorare.net (Postfix) with ESMTPSA id B4D77A2C09
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2015 12:30:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I was just looking through the ulogd2 source to get a handle on some of the netfilter APIs and noticed something odd in ulogd_inpflow_NFCT.c/build_nfct_filter_dir().[1][2] Unless I'm missing something, it appears that nfct_filter_add_attr is being passed a pointer to uninitialized stack memory.

Thanks,
Peter


[1] http://git.netfilter.org/ulogd2/tree/input/flow/ulogd_inpflow_NFCT.c#n1167
[2] http://git.netfilter.org/ulogd2/tree/input/flow/ulogd_inpflow_NFCT.c#n1179