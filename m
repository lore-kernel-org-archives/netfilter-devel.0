From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH RFC 0/3] conntrack: add interface information to accounting extend
Date: Thu, 26 Sep 2013 17:31:50 +0200
Message-ID: <20130926153150.280914229@eitzenberger.org>
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IZPkR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:40:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

there are quite some IPFIX collectors (both commercial and not),
which rely on the exported accounting data to contain the interface
index the packet arrived, as well as the interface index the packet
left the box.  This is AFAIK not mandated by the RFC, but just a
de facto standard set by those vendors.

Those collectors then often don't work if interface data is missing.

I try to solve this by adding the missing interface data to the
accounting extend.  See following three patches.

First patch encapsulates both directions of the extend data into a
newly introduced nf_conn_acct.  This could make sense even if not
adding interface indices later.

2nd patch coalesces two calls of ctnetlink_dump_counters() into a
single call of newly created ctnetlink_dump_acct(), with the intent
to add interface info in the following patch.  ABI stays the same.

The 3rd patch then adds the interface indices to the accounting
extend.  I chose to wrap both inside a newly introduced CTA_ACCT
attribute in the hope to improve the situation for readers not using
this extend.  At the cost of adding another 'nlattr' to the output:

 <CTA_ACCT>
   <CTA_ACCT_INDEV, u32>
   <CTA_ACCT_OUTDEV, u32>

Please check the patches, I appreciate your comments.

Thanks.

 /Holger

