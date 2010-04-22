From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] bridge-netfilter patch version 13 for 2.4.37.9
Date: Thu, 22 Apr 2010 17:41:39 +0200
Message-ID: <4BD06E33.4050107@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:35668 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab0DVPlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:41:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I just release version 13 of the bridge-netfilter patch for kernel 2.4.
It adds the following bugfix:

- fix leak in bridge netfilter if the packet tarverses more than one
bridge on the host (fix by David Kimdon)

See http://ebtables.sourceforge.net/downloads/latest.html

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
