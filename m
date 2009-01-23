From: "Jacky Luk" <jacky.luk@primecreation.com>
Subject: Is the libnetfilter_queue thread-safe?
Date: Fri, 23 Jan 2009 12:02:21 +0800
Message-ID: <web-4707182@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n218103092061.netvigator.com ([218.103.92.61]:53895 "EHLO
	mail.primecreation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZAWFHt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:07:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I would like to ask a question about the 
libnetfilter_queue. Is the libnetfilter_queue thread-safe? 
Would the API of libnetfilter_queue cause the kernel crash 
under multi-threading environment? I am using the Red Hat 
Enterprise Linux 5.2 with the kernel version 
2.6.18-92.el5PAE to develop my own program. The version of 
libnetfilter_queue is 0.0.16 and the version of 
libnfnetlink is 0.0.40.

Thanks and Regards,

Jacky Luk
