From: Lutfi <lutfio@metu.edu.tr>
Subject: About IPset 6.2 Time out problem
Date: Tue, 17 May 2011 09:24:26 +0300
Message-ID: <4DD2149A.9060603@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from likya.general.services.metu.edu.tr ([144.122.144.158]:37006
	"EHLO mail.metu.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1EQGeS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2011 02:34:18 -0400
Received: from [144.122.3.229] (sandal.cc.metu.edu.tr [144.122.3.229])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.metu.edu.tr (Postfix) with ESMTPSA id EC3CB5052B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2011 09:24:14 +0300 (EEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am using a ipset 6.2 on my Deiban 6.0 64 bit box with kernel 2.6.37.2.
I got a set that i created by using the command "ipset create XXX iptree
--timeout 10800". After a while timeout values increases to billions of
seconds.
What may be the problem?

Thanks,

Lutfi
