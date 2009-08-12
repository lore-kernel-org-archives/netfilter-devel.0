From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: [bug?] netfilter/ipvs : suspected race bugs related to atomic
	operations
Date: Wed, 12 Aug 2009 23:43:39 +0900
Message-ID: <2014bcab0908120743w2d96c359t818729b64c9da62b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62854 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZHLOnl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:43:41 -0400
Received: by yxe5 with SMTP id 5so70990yxe.33
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2009 07:43:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. I am reporting two suspected race bug related to atomic operations
while I read net/netfilter/ipvs of Linux 2.6.30.4.

(1) In net/netfilter/ipvs/ip_vs_core.c, ip_vs_in() first increments &cp->in_pkts
     and then reads variable for condition checking at line 1346-1351.

     However, these two atomic operations may not be executed atomically.
     For this reason, it may result race with other concurrent executions
     which manipulates &cp->in_pkts.

(2) In net/netfilter/ipvs/ip_vs_wrr.c, ip_vs_wrr_max_weight() first
checks &dest->weight
     and then reads the variable again to assign its value to a local variable.
     For the similar reason above, it seems that two atomic_read() operations
     may result different values so that it may result race condition.

Please examine the code and let me know your opinion. Thanks.

Sincerely
Shin Hong
