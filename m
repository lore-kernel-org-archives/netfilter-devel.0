From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Data rate of a connection using conntrack
Date: Tue, 6 Oct 2009 20:46:43 +0530
Message-ID: <4d5b51f60910060816i35c9ffd8y9bf2695f9d28bca3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:17064 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbZJFPRv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:17:51 -0400
Received: by ey-out-2122.google.com with SMTP id 4so819649eyf.19
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2009 08:16:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I understand from RATEEST that data rate of an interface is estimated
using the gen_new_estimator , which is also used by the TC , qdisc n
folks ...
Has anybody tried to estimate the data rate of a connection using conntrack ?
Anyone's previous attempts or experiences  are welcome.
Thanks,
Anand
