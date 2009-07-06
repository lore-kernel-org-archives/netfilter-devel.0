From: Ritesh Majumdar <r.majumdar@globallogic.com>
Subject: netfilter/iptables hashlimit query
Date: Mon, 06 Jul 2009 11:57:16 +0530
Message-ID: <1246861636.19710.100.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:34998 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbZGFGkp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:40:45 -0400
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id ha6dpc0171su for <netfilter-devel@vger.kernel.org>; Mon, 6 Jul 2009 12:07:07 +0530 (envelope-from <R.Majumdar@globallogic.com>)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

I using kernel 2.6.27 and iptables-1.4.1. I want to use the iptables
hashlimit feature. while looking through haslimit mode options I found
that it has srcip,srcport,dstip,dstport only. 

I was wondering if this has any options like srcnet and dstnet also. or
if not available , how can we include this fetaure ?


Many Thanks,
Ritesh.
