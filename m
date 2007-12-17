From: Shane Kelly <s.kelly@physics.gla.ac.uk>
Subject: Information on proc entries for nf_conntrack and xt_conntrack
Date: Mon, 17 Dec 2007 13:01:53 +0000
Message-ID: <47667341.9060206@physics.gla.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from desdemona.physics.gla.ac.uk ([130.209.202.229]:53710 "EHLO
	desdemona.physics.gla.ac.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760609AbXLQNcV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:32:21 -0500
Received: from othello.physics.gla.ac.uk ([130.209.204.200]:42754)
	by desdemona.physics.gla.ac.uk:25 with esmtp  (Exim 4.66)
	id 1J4FbV-0006E4-SZ
	for netfilter-devel@vger.kernel.org; Mon, 17 Dec 2007 13:01:53 +0000
Received: from gw-trusted.physics.gla.ac.uk ([130.209.204.195]:50323 helo=dhcp-trusted-110.physics.gla.ac.uk)
	by othello.physics.gla.ac.uk:587 with esmtpsa  (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.60)
	id 1J4FbV-0004P0-Mi
	for netfilter-devel@vger.kernel.org; Mon, 17 Dec 2007 13:01:53 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
	I have a need for a bridged firewall and while I have managed to get this 
working, I would like to be pointed to any/all documentation regarding the 
settings the nf/xt/ip modules place in the /proc file system, with a view to 
understanding if I could tune them for smoother/faster/more efficient running 
of the firebridge.

Any pointers appreciated.

Thanks

Shane
-- 
Shane Kelly
Faculty IT Manager
Faculty of Physical Sciences
Room 238
Kelvin Building
University of Glasgow

Tel: 0141 330 2956
