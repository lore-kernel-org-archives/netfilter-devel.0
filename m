From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [FIX 0/1] sip: add missing RCU reader lock in set_expected_rtp_rtcp()
Date: Fri, 20 Sep 2013 17:52:17 +0200
Message-ID: <20130920155217.281613399@eitzenberger.org>
Cc: <kaber@trash.net>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3ITP6W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:58:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I noticed that set_expected_rtp_rtcp() in net-next misses a 2nd
RCU reader lock when dereferencing the 2nd hook function.  Same
bug is present in kernel v3.8 at least.

It is not simply a matter of extending the RCU read protected
area because there is a conditional return in between:

    if (skip_expect)
        return NF_ACCEPT;

Please check the RCU usage.  I see e. g. that nf_ct_expect_related(),
takes nf_conntrack_lock, but my understanding of RCU is that
this is ok.

Thanks.

 /Holger

