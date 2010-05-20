From: Patrick McHardy <kaber@trash.net>
Subject: iptables-next merged into master
Date: Thu, 20 May 2010 17:12:47 +0200
Message-ID: <4BF5516F.9060809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54398 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0ETPMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 11:12:46 -0400
Received: from [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8] (unknown [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 46ECAB2C51
	for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 17:12:45 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that the 1.4.8 release is out, I've merged the iptables-next
branch into the master branch, meaning it now contains support
for the TEE target.
