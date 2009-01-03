From: VPF <videopacketfilter@gmail.com>
Subject: Bug in Netfiler_queue when using small packets in 100Mb traffic
Date: Sat, 3 Jan 2009 15:38:29 +0100
Message-ID: <d579762c0901030638k3ddcac6dy8ee175244eaddbe9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-1718.google.com ([74.125.46.153]:22139 "EHLO
	yw-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZACOic (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:38:32 -0500
Received: by yw-out-1718.google.com with SMTP id 5so2994379ywm.32
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Jan 2009 06:38:29 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I encountered a problem with the example nfqnl_test.c when I sent
100Mb/s of <200ko packets. The program stopped running quickly and
printed "unbinding from queue 0". It appears that the call recv(fd,
buf, sizeof(buf), 0) returns an error after a few packets. (errno 105
: No buffer space available).

Do you see any solution to this problem?
