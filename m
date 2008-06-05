From: Patrick McHardy <kaber@trash.net>
Subject: [Fwd: commit header lines...]
Date: Thu, 05 Jun 2008 17:50:38 +0200
Message-ID: <48480B4E.3060402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46873 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFEPul (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:50:41 -0400
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTP id 09654948F7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Jun 2008 17:50:39 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

FYI. Please also follow this convention for netfilter patches
from now on.

-------- Original Message --------
Subject: commit header lines...
Date: Wed, 04 Jun 2008 15:56:18 -0700 (PDT)
From: David Miller <davem@davemloft.net>
To: netdev@vger.kernel.org


Some of you may have noticed, but I have been editing commit
header lines to be more in tune with what people use in the
rest of the kernel and what is facilitated best by the tools.

This basically means:

subsystem: Commit description

Where "subsystem" is in lower case and not surrounded by
"[" and "]" as we previously did in the past.

Please try to adhere to this in your patch submissions as
it saves work for me.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

