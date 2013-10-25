From: Christian Priebe <chr.priebe@googlemail.com>
Subject: libnetfilter_queue/libnetfilter_conntrack: TCP packet reordering
Date: Fri, 25 Oct 2013 14:30:27 +0100
Message-ID: <526A7273.2010800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49600 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3JYNaa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:30:30 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so3842896wgg.20
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2013 06:30:28 -0700 (PDT)
Received: from ?IPv6:2001:630:12:2e20:ad59:71e0:f91a:87d8? ([2001:630:12:2e20:ad59:71e0:f91a:87d8])
        by mx.google.com with ESMTPSA id w10sm6180223wia.4.2013.10.25.06.30.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 25 Oct 2013 06:30:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

since Netfilter is working on the network level my understanding would 
be that in case one want to use libnetfilter_queue to get to the full 
content sent through a TCP connection, reassembly and reordering of TCP 
segments have to be done by yourself.

I've looked at the source code of the l7-filter [1] project which uses 
netfilter queues as well as conntrack to reassemble packets and do a 
regular expression search to be able to determine protocols based on 
application layer data. Apparently the only thing they do is to append 
data from incoming packets of the same connection to a buffer without 
ever looking at sequence numbers.

My question therefore is: Is my understanding wrong and Netfilter 
(potentially with enabled conntrack modules) already reorders TCP 
segments according to their sequence numbers or did I miss something and 
you would have to do it on your own?

[1] http://l7-filter.clearfoundation.com

Thanks in advance!


Best wishes,
Christian
