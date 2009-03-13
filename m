From: BORBELY Zoltan <bozo@andrews.hu>
Subject: crash bug due to a missing initialization
Date: Fri, 13 Mar 2009 12:18:18 +0100
Message-ID: <20090313111818.GA5359@zebra.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx8.datanet.hu ([194.149.13.161]:54784 "EHLO mx8.datanet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZCMLvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:51:53 -0400
Received: from dolphin (s6x0wafs3x.adsl.datanet.hu [91.120.103.114])
	by mx8.datanet.hu (DataNet) with ESMTP id 5312FEBE3A
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2009 12:18:19 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

In the ctnetlink_create_expect() function (in file nf_conntrack_netlink.c),
you forgot to initialize exp->class, which causes a crash in the
nf_ct_expect_related() function. I've just put an

    exp->class = 0;

line before the exp->expectfn = NULL line, and it has solved the problem.

Bye,
Bozo
