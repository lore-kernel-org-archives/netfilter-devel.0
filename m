From: Patrick McHardy <kaber@trash.net>
Subject: ipt_addrtype: limit address type checking to an interface
Date: Thu, 05 Jun 2008 16:04:23 +0200
Message-ID: <4847F267.6030105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: laszlo@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43930 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYFEOEZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:04:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just noticed we never added the userspace support
for the new addrtype feature. Please send me patch
for iptables so I can add it. Thanks.

