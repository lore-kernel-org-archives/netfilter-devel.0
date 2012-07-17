From: David Miller <davem@davemloft.net>
Subject: That's pretty much it for 3.5.0
Date: Tue, 17 Jul 2012 09:01:42 -0700 (PDT)
Message-ID: <20120717.090142.125145009944045241.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:51115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2GQQBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:01:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Linus was _extremely_ generous and took in all the stuff that was
pending in the net tree just now.

Besides very serious issues, I'm not willing to consider any more bug
fixes for the 'net' tree at this time.

Only one pending known bug qualifies, and that's the CIPSO ip option
processing OOPS'er.  And I'll work on that myself if Paul Moore
doesn't show a sign of life in the next day.

Thanks.
