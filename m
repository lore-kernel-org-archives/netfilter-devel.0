From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 19:23:19 +0100
Message-ID: <499B0097.4000505@trash.net>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Joe Pruett <joey@clean.q7.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZBQSXV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:23:21 -0500
In-Reply-To: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joe Pruett wrote:
> trying this again on the -devel list.  the basic question i'm trying to 
> answer is if there really isn't a way to filter esp/ah packets after 
> decryption/decapsulation in host2host mode.  i've looked at what i think 
> is the current linus kernel and don't see any changes to esp/ah handling 
> to address this.  is tunnel mode the only way i can do filtering on the 
> packets after ah/esp have done their work?

Packets in both tunnel and transport mode traverse the netfilter hooks
after decapsulation and before encapsulation. From a users POV there
should be nothing special about it.
