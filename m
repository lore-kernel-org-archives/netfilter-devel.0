From: GLAUME Vincent <vincent.glaume@cea.fr>
Subject: Using conntrack to create new expectation entry
Date: Mon, 14 Jun 2010 10:21:49 +0200
Message-ID: <4C15E69D.3070400@cea.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cirse-out.extra.cea.fr ([132.166.172.106]:48011 "EHLO
	cirse-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0FNJX2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:23:28 -0400
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by cirse.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with ESMTP id o5E8Lo7q004016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 10:21:50 +0200
Received: from muguet2.intra.cea.fr (muguet2.intra.cea.fr [132.166.192.7])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o5E8LoiD012845
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 10:21:50 +0200
	(envelope-from vincent.glaume@cea.fr)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet2.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with SMTP id o5E8Ln7J009111
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 10:21:49 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

I'm currently trying to figure out how the whole libnetfilter_conntrack 
works, and more precisely the expect part of the lib.
My aim is to be able to create new expectation entries with this lib in 
an application that would inspect packets (either coming from a 
pcap-based sniffer or from netfilter via the nfqueue mechanism) : thus 
I'd like to allow connections related to the inspected (and already 
allowed) connections.

My various tests make me think that to create such an expectation entry, 
a kernel module related to the master connection is required: am I right?
For instance, the "expect_create" app in the libnetfilter_conntrack 
"utils" subdirectory works fine, unless I modify the destination port of 
the master conntrack structure... then it's no longer related to the FTP 
conntrack mechanism...
Same thing happens when using the conntrack app. from the conntrack-tools.

So, I'd like to know how to do this the right way, without coding the 
whole inspection thing in a kernel module (if this is possible). Is 
there any generic tcp conntrack system that could help here?
As I'm not too sure to fully understand the whole mechanism of expected 
connection creation, any hint is welcome!
I hope this is not too confused... Thanks,

-- 
V.
