From: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Subject: Support marking/matching tc_index in netfilter
Date: Fri,  4 Dec 2015 10:59:10 +1300
Message-ID: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:46076 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbLCV7h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 16:59:37 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 71890805C9
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2015 10:59:30 +1300 (NZDT)
Received: from luukp-dl.ws.atlnz.lc (luukp-dl.ws.atlnz.lc [10.33.11.25])
	by smtp (Postfix) with ESMTP id 16B4413EC51
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2015 10:50:36 +1300 (NZDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

This patch is related to the recent discussion around increasing the skb->mark
size.

Given that increasing the size of the skb is undesirable, this patch makes use
of existing space in the skb reserved for tc marking and adds the possibility
to do that marking from netfilter code.  For performance reasons, the ability
to save/restore this mark to the connection has also been added.

The existing tcindex filter in the scheduler means that no changes are required
there.

This is a first draft, but I think it is reasonably complete in terms of the kernel
code required.

