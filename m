From: "hanasaki@gmail.com" <hanasaki@gmail.com>
Subject: iptc_handle : where is header and structure info for iptc_handle
 ?
Date: Sun, 22 Dec 2013 00:01:38 -0600
Message-ID: <52B68042.5030807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50207 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3LVGBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Dec 2013 01:01:42 -0500
Received: by mail-pa0-f41.google.com with SMTP id lf10so4248006pab.28
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Dec 2013 22:01:41 -0800 (PST)
Received: from [10.1.1.30] (cpe-98-156-78-19.kc.res.rr.com. [98.156.78.19])
        by mx.google.com with ESMTPSA id ja5sm25195547pbc.14.2013.12.21.22.01.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 21 Dec 2013 22:01:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Running a build of 3.12 with iptables and looking for the header file 
with the full structure of the "iptc_handle" without success.  Any tips?

built on debian wheezy with the headers.  installed the header and 
source packages for this and the bundled kernel 3.10.

Using this as a reference
	http://www.tldp.org/HOWTO/Querying-libiptc-HOWTO/qfunction.html

Linux myhost 3.12.1 #1 SMP PREEMPT Sun Nov 24 09:37:33 CST 2013 x86_64 
GNU/Linux
