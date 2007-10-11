From: Ben Sartor <BenSar@web.de>
Subject: RFC Announce active-active solution: availability-manager
Date: Thu, 11 Oct 2007 16:35:12 +0200
Message-ID: <200710111635.12529.BenSar@web.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38095 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXJKOfR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:35:17 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id 3D9B9A2CFC4C
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Oct 2007 16:35:15 +0200 (CEST)
Received: from [87.78.65.170] (helo=[192.168.1.187])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.108 #197)
	id 1Ifz86-0006GJ-00
	for netfilter-devel@vger.kernel.org; Thu, 11 Oct 2007 16:35:15 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi!

During my diploma thesis which was sponsored by credativ (www.credativ.de) I 
implemented an active-active firewall solution. It implements a loadbalancing 
cluster that is able to detect new nodes (on-the-fly integration) and failed 
ones. Furthermore, it synchronizes the connection tracking table of the 
nodes, so that at a failover no connection gets lost.

In order to achieve this the kernelmodule "clusterdev" was implemented. It is 
based on Harald Welte's "clusterip" and so it uses a multicast MAC address to 
share an IP address on multiple nodes. Which node is responsible for a 
connection is determined by a responsible range (0 ... 255) assigned to each 
node.

The second part of my solution is the userspace 
application "availability-manager". It sets the responsible range and 
implements a simple heartbeat protocol. Furthermore, it uses 
libnetfilter-conntrack to make sure the connection tracking table of each 
node is known by the others. Thus at a failover the connection tracking 
entries can be reallocated among the remaining nodes.

The software is released under the GPL and can be downloaded at:

http://sourceforge.net/projects/avail-manager/

A translation of my diploma talk can be found at:

http://avail-manager.sourceforge.net/talk.pdf

I tested the software with kernel 2.6.22 and libnetfilter_conntrack-0.0.81. 
For the future it is planned to include IPv6 support. Furthermore I think it 
may be possible to make it work with "clusterip".

Although I consider the software to be in a pre-alpha state, it runs quite 
stable in a productive environment at the credativ GmbH. Any comments are 
highly appreciated.



Regards

  Ben Sartor
