From: Casper Gripenberg <casper.gripenberg@kotiportti.fi>
Subject: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Tue, 01 Apr 2008 20:34:53 +0300
Message-ID: <47F2723D.2080509@kotiportti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63663 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbYDASiG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:38:06 -0400
Received: from a91-152-80-82.elisa-laajakaista.fi ([91.152.80.82])
	by mho-01-bos.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <casper.gripenberg@kotiportti.fi>)
	id 1JgkO4-000GGh-0s
	for netfilter-devel@vger.kernel.org; Tue, 01 Apr 2008 17:35:08 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

I sent this to the netfilter list, but nobody replied there.

I've found something strange with REJECT and DNAT rules
where the MAC address for packets coming back through
the bridge get rewritten incorrectly.

The setup to test this is fairly simple, and I can
reproduce it consistently on my stock Ubuntu 7.10
installation (kernel 2.6.22-14).

Is it something I'm doing wrong, or any idea what is
going on? I filed a bug report here:

https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=531

Thanks.

Casper

