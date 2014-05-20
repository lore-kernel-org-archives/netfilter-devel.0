From: Andreas Herz <andi@geekosphere.org>
Subject: function for getting the source ip defined in the routing table
Date: Tue, 20 May 2014 14:46:34 +0200
Message-ID: <20140520124634.GM10939@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:55227 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETMqh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2014 08:46:37 -0400
Received: from geekosphere.org (unknown [IPv6:2a00:f48:1026:0:f1f7:0:1545:173f])
	by mail.geekosphere.org (Postfix) with ESMTPSA id 3B80DF4FA4
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2014 12:46:35 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

i was looking for a function to get the source ip that is defined in the
routing table. I looked into the MASQUERADE module but the
"inet_select_addr" function returns the source ip from the interface
(the first one, in most use cases).

See the following routing table entry:

10.0.13.0/24 dev eth1  proto kernel  scope link  src 10.0.13.4

while the interface has multiple IPs:

    inet 10.0.12.1/24 scope global eth0
    inet 10.0.13.2/24 scope global eth0
    inet 10.0.13.4/24 scope global secondary eth0

So what i want is the value of the src part in the routing table (for connections to the related network).

thanks.

-- 
Andreas Herz
