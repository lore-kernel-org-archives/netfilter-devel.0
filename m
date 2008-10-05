From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 18:22:53 +0200
Message-ID: <48E8E9DD.4090001@trash.net>
References: <48E8D3C4.60306@trash.net>	<20081005.090202.143862823.davem@davemloft.net>	<48E8E736.8060800@trash.net> <20081005.091739.131587847.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48642 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbYJEQW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:59 -0400
In-Reply-To: <20081005.091739.131587847.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 05 Oct 2008 18:11:34 +0200
> 
>> I'm not sure how emacs handles completion, would using different
>> prefixes for matches and targets help? Otherwise I guess we can
>> just get rid of the prefixes entirely.
> 
> Putting them in different sub-directories would help.

OK, lets do that as a start.
