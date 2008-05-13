From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] Make --set-counters (-c) accept comma separated counters
Date: Tue, 13 May 2008 12:57:33 +0200
Message-ID: <4829741D.3030506@trash.net>
References: <1210624575.3442.56.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38625 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYEMK6L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 06:58:11 -0400
In-Reply-To: <1210624575.3442.56.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> Here is the --set-counters syntax patch requested earlier today making
> --set-counters (-c) accept comma separated counts.
> 
> -c packets,bytes
> 
> I have not updated the manpage to reflect this alternate syntax for the
> --set-counters (-c) option.

Also applied, thanks Henrik.
