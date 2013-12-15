From: "hanasaki@gmail.com" <hanasaki@gmail.com>
Subject: iptc_handle : finding header and structure info
Date: Sat, 14 Dec 2013 18:25:40 -0600
Message-ID: <52ACF704.7030602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45733 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3LOAZs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Dec 2013 19:25:48 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so3943501pde.27
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2013 16:25:47 -0800 (PST)
Received: from [10.1.1.30] (cpe-98-156-78-19.kc.res.rr.com. [98.156.78.19])
        by mx.google.com with ESMTPSA id yg3sm20630321pab.16.2013.12.14.16.25.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 14 Dec 2013 16:25:46 -0800 (PST)
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
