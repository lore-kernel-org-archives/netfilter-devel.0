From: "Jacky Luk" <jacky.luk@primecreation.com>
Subject: About the using of libnetfilter_queue!
Date: Wed, 05 Nov 2008 00:14:07 +0800
Message-ID: <web-4630504@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Cc: michael.tso@primecreation.com, michael.soong@primecreation.com
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n218103092061.netvigator.com ([218.103.92.61]:52486 "EHLO
	mail.primecreation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbYKDQSN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:18:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have some questions about the using of 
libnetfilter_queue. I use the RHEL 5.2 to develop my 
application (Kernel: 2.6.18-92.el5). I found that there 
are several strange phenomena when using the API of the 
libnetfilter_queue.

1. The nfq_get_timestamp() always returns the same value 
of the timestamp for all packets retrieved from the 
NFQUEUE. What is the cause of this problem?

2. I cannot set the maximum length of the queue by using 
the function nfq_set_queue_maxlen(). This function always 
returns -1 even though I have inputted the correct 
parameters into this function. I have searched about this 
issue in Google and someone said that kernel >= 2.6.20 
would be supported to use this function. Is it true? If 
so, how can I set the maximum length of the queue when I 
use the kernel = 2.6.18?

Thank you very much!

Regards,

Jacky Luk
