From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 2/4] Add support for --set-counters to iptables -P
Date: Mon, 12 May 2008 20:40:26 +0200
Message-ID: <48288F1A.6070807@trash.net>
References: <1210616702.3442.33.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbYELSlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:41:03 -0400
In-Reply-To: <1210616702.3442.33.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> Adds support for setting the policy counters
> 
> iptables -P INPUT -J DROP -c 10 20

Applied, thanks.
