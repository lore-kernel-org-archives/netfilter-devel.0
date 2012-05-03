From: Flo Wohlfart <wohlfart@in.tum.de>
Subject: ICMP packet filter policy
Date: Thu, 03 May 2012 18:32:13 +0200
Message-ID: <4FA2B30D.7000403@in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:38331 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab2ECQlB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 May 2012 12:41:01 -0400
Received: from [192.168.1.194] (r029088.stusta.swh.mhn.de [10.150.29.88])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTPSA id C10402401D8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 May 2012 18:32:12 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

due to a bug in a home-router, I had to deal with ICMP packets with a 
wrong checksum. I discovered that netfilter does not drop ICMP packets 
with a wrong checksum in the ICMP header.

I have set up IP forwarding and NAT on a Debian host using iptables. On 
this host iptables/netfilter allows outgoing "ICMP destination 
unreachable" packets with a wrong ICMP checksum. These ICMP packets are 
translated by NAT and forwarded to the public network interface.

When I replace the Debian host with an OpenWRT router, outgoing "ICMP 
destination unreachable" packets need to have a correct checksum. 
Otherwise they are dropped. OpenWRT also uses iptables/netfilter for 
packet filtering and NAT. However, there is no iptables-rule that could 
explain this behavior.

I would like to know why these two versions of netfilter behave 
differently. Is there a configuration option to tell netfilter to filter 
these messages? Should NAT implementations filter these ICMP messages 
with a wrong checksum?

I know this is a rather special issue, but maybe someone can help :)

Regards
Florian Wohlfart
