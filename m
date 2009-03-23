From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Mon, 23 Mar 2009 14:09:39 +0100
Message-ID: <49C78A13.8080709@trash.net>
References: <49C202EA.40006@trash.net> <Pine.LNX.4.64.0903211542140.7844@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZCWNJs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:09:48 -0400
In-Reply-To: <Pine.LNX.4.64.0903211542140.7844@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> On Thu, 19 Mar 2009, Patrick McHardy wrote:
> 
>> I've planned to release the next iptables version sometime (late)
>> this weekend. We've had quite a lot of changes since the last
>> version, please test the latest version from git and report any
>> issues.
> 
> I just realized a bug in libiptc.c in func TC_RENAME_CHAIN.
> The rename should insert the new chain name sorted, as my binary search 
> system / skip-list rely on it.
> 
> I don't have time to fix it until monday. Jan, feel free to fix it up 
> before I do...

I'll wait with the release until someone sends me a patch :)
