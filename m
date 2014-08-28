From: Alex Chapman <ajchapman88@hotmail.co.uk>
Subject: RE: vmap verdict on two matched meta types
Date: Thu, 28 Aug 2014 13:30:15 +0100
Message-ID: <DUB109-W96FC98130381AAD4C1F72EE1DA0@phx.gbl>
References: <DUB109-W1309363CFF7E6B2F3D8EA2FE1DA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub004-omc1s18.hotmail.com ([157.55.0.217]:57635 "EHLO
	DUB004-OMC1S18.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbaH1MaQ convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:30:16 -0400
In-Reply-To: <DUB109-W1309363CFF7E6B2F3D8EA2FE1DA0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologies I meant to send this to the user list. Can it be moved?

Thanks

----------------------------------------
> From: ajchapman88@hotmail.co.uk
> To: netfilter-devel@vger.kernel.org
> Subject: vmap verdict on two matched meta types
> Date: Thu, 28 Aug 2014 11:41:00 +0100
>
> Hi,
>
> I'm wondering if it's possible to configure a map that produces a verdict based on two different meta types. For example where you could give a jump verdict based on the iif AND oif?
>
> Something like:
>
> map jump_map {
> type ifindex, type oifindex : verdict
> }
>
> Thanks!
>
>
>
 		 	   		  