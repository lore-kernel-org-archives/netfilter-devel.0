From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: half a patch for the pseudoregression
Date: Mon, 09 Feb 2009 17:20:44 +0100
Message-ID: <499057DC.9000102@trash.net>
References: <alpine.LSU.2.00.0901272322210.31372@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZBIQUr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:20:47 -0500
In-Reply-To: <alpine.LSU.2.00.0901272322210.31372@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> Here is the sample patch that fixes ip_tables_matches, but I still 
> challenge the usefulness of /proc/net/ip_tables_* altogether.
> Those files should have been removed, or appropriately upgraded when 
> revision support was introduced.

Thats not really the question right now since it exists and people
are using it. Feel free to start a discussion on removing it once
we've fixed the regression.

> netfilter: make proc/net/ip_tables_matches print names from foreign NFPROTO
> 
> The ugliness this code adds could have been better spent at
> a full and much more helpful dump.

This might get easier by simply using the same mutex for all families.
Not sure if its worth it, in any case not for now.

The patch looks fine, please resubmit when you have fixed the second
half with proper changelog (stating that it fixes a regression and
the commit introducing it).
