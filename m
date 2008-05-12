From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 3/4] iptables --list-rules command
Date: Mon, 12 May 2008 20:42:19 +0200
Message-ID: <48288F8B.30503@trash.net>
References: <1210617499.3442.41.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50312 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951AbYELSm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:42:56 -0400
In-Reply-To: <1210617499.3442.41.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> Adds iptables --list-rules (-S) command, acting as a combination of
> iptables --list and iptables-save.
> 
> The primary motivation behind this patch is to get iptables-save like
> output capabilities in iptables-restore, allowing "iptables-restore -n"
> to be used as a consistent API to iptables for all kind of operations,
> not only blind updates..
> 
> As a bonus iptables also gets the capability of printing the rules
> as-is.
> 
> This completely replaces the earlier patch which added the --rules
> option.


Looks good to me. I'll let this sit on the list until tommomrrow
in case anyone has comments.
