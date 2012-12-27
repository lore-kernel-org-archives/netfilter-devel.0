From: Patrick McHardy <kaber@trash.net>
Subject: Re: [libnl-nft PATCH] Fix out of bounds buffer access in
 rtnl_netem_set_delay_distribution()
Date: Thu, 27 Dec 2012 07:23:12 +0100 (MET)
Message-ID: <Pine.GSO.4.63.1212270722420.1519@stinky-local.trash.net>
References: <50D9B4FF.9000806@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58965 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2L0GXT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:23:19 -0500
In-Reply-To: <50D9B4FF.9000806@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Dec 2012, Thomas Jarosch wrote:

> sizeof(test_path) returns the array size
> and not the number of array elements.
>
> Detected by cppcheck

Is this already fixed in libnl upstream? I'm considering just doing a full 
merge.

