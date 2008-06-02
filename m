From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] export conntrack status also on destroy event
Date: Mon, 02 Jun 2008 11:52:53 +0200
Message-ID: <4843C2F5.6040104@trash.net>
References: <1211447594.6878.37.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62898 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYFBJw6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:52:58 -0400
In-Reply-To: <1211447594.6878.37.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> When a conntrack is destroyed, the connection status does not get 
> exported to netlink. I don't see a reason for not doing so. This patch 
> exports the status on all conntrack events.

Applied, thanks. I've added the missing Signed-off-by: line for you,
please object in case you're not OK with this.


