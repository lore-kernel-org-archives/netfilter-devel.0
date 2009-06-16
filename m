From: Volker Poplawski <volker@openbios.org>
Subject: libnl: initial cache fill
Date: Tue, 16 Jun 2009 13:11:38 +0200
Message-ID: <200906161311.38251.volker@openbios.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from khepri.openbios.org ([80.190.231.112]:5168 "EHLO
	khepri.openbios.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZFPL34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:29:56 -0400
Received: from dip-112-191.bras.dsl.breisnet.com ([82.194.112.191] helo=kiwi.localnet)
	by khepri.openbios.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <volker@openbios.org>)
	id 1MGWZt-0000ZL-PR
	for netfilter-devel@vger.kernel.org; Tue, 16 Jun 2009 13:11:45 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

Why is
nl_cache_request_full_dump ()
not part of the public api of libnl?

Or do i miss the intended way for an initial cache fill when using the cache-
manager? 

And BTW: What actually is part of the public api?
The doxygen docs on libnl give no clue about what is for applications and what 
is used internally.



Greetings
....Volker



