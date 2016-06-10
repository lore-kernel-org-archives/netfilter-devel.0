From: Thomas Woerner <twoerner@redhat.com>
Subject: ip6tables: Warn about use of DROP in nat table
Date: Fri, 10 Jun 2016 12:16:13 +0200
Message-ID: <37eef83b-8e81-b3ae-3dea-e51a913b3e2e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbcFJKQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 06:16:15 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B727072D2F
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 10:16:14 +0000 (UTC)
Received: from brasilia.fritz.box (brasilia.str.redhat.com [10.33.200.35])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u5AAGD8J031419
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 06:16:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

in iptables.c there is a check of DROP usage in the nat table.In 
ip6tables, this check is not there.Is this intentional?

These are the commits for iptables that added and modified the 
check:1eada72b, 9bb76094 and e0390bee

What do you think about adding this also to ip6ables?

Regards,
Thomas
