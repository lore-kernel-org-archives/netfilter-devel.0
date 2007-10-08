From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFCT_Q_UPDATE and IPv6
Date: Mon, 08 Oct 2007 07:11:01 +0200
Message-ID: <4709BBE5.1000902@trash.net>
References: <OF38CFDD8B.3B74F76F-ONC125736B.0053E9D0-C125736B.0055898A@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: laurent.brando@mindspeed.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51663 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXJHFNX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 01:13:23 -0400
In-Reply-To: <OF38CFDD8B.3B74F76F-ONC125736B.0053E9D0-C125736B.0055898A@mindspeed.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

laurent.brando@mindspeed.com wrote:
> Hi,
> 
> I'm facing some issues trying to update UDP/TCP timeout attribut of an 
> existing Ipv6 conntrack. 
> 
> It looks like call to nfct_query(ct_handler, NFCT_Q_UPDATE, ct) never 
> returns and my application thread
> gets killed.
> 
> I'm about to put some debug after the call to nfct_query , but I would 
> like to know if any of you is aware of such
> problem or  similar issue. 
> 
> Also, any proposal to narrow down the issue in an efficient way would be 
> appreciated.


Try running it under gdb to find out what happens.
