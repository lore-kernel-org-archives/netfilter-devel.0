From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Wed, 13 Apr 2011 13:37:06 +0200
Message-ID: <4DA58AE2.7000204@trash.net>
References: <20110412215458.3145.40830.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38645 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab1DMLhK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:37:10 -0400
In-Reply-To: <20110412215458.3145.40830.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12.04.2011 23:59, schrieb Pablo Neira Ayuso:
> Hi Patrick,
> 
> The following patches rework the userspace expectation support
> to fix one problematic scenario: if the master conntrack vanishes
> while there are still userspace expectations, we hit an oops
> in the destroy event path for expectations.

Just wondering, how can this happen? We take a reference for
userspace expectations just as we do for kernel expectations.

Ok, I see, we are releasing it again at the end of
ctnetlink_create_expect(), that seems to be the actual problem
if I'm not mistaken.

> 
> The idea to fix this is to extend the iptables CT target to
> explicit allocate the helper extension for conntracks that
> are suppose to behave as master for user-space expectations.
> 
> In the case of the userspace FTP helper, people would need
> to add the following rule:
> 
> iptables -A PREROUTING -t raw \
> 	-p tcp --dport 21 -j CT --userspace-helper
> 
> Thus, we can store the list of expectations that belong to
> one master, and delete them in case that the master vanishes.
