From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [libnl-nft PATCH] Fix out of bounds buffer access in rtnl_netem_set_delay_distribution()
Date: Thu, 27 Dec 2012 10:48:17 +0100
Message-ID: <1410061.iSsmj8ob8e@storm>
References: <50D9B4FF.9000806@intra2net.com> <Pine.GSO.4.63.1212270722420.1519@stinky-local.trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:54482 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2L0JsU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:48:20 -0500
In-Reply-To: <Pine.GSO.4.63.1212270722420.1519@stinky-local.trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 27. December 2012 07:23:12 Patrick McHardy wrote:
> On Tue, 25 Dec 2012, Thomas Jarosch wrote:
> > sizeof(test_path) returns the array size
> > and not the number of array elements.
> > 
> > Detected by cppcheck
> 
> Is this already fixed in libnl upstream? I'm considering just doing a full
> merge.

This one has been fixed upstream.

(I wasn't even aware there's an upstream... I just tested
some cppcheck changes on the git trees I had on disc)

