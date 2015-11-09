From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nf-next 0/1] payload mangling support
Date: Mon, 9 Nov 2015 15:37:05 +0000
Message-ID: <20151109153704.GJ8098@macbook.localdomain>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
 <alpine.LSU.2.20.1511091613300.8566@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:49044 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672AbbKIPhI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 10:37:08 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1511091613300.8566@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.11, Jan Engelhardt wrote:
> 
> On Monday 2015-11-09 15:10, Patrick McHardy wrote:
> 
> >The following patch adds support for payload mangling. It supports updating
> >all fields except those included in pseudo headers since it only supports a
> >single checksum update operation. So it can not be used for stateless NAT.
> >
> >Checksum updates currently only support internet checksums and assume the
> >mangled data is actually covered by the checksum. Userspace only allows use
> >for these protocols.
> >
> >So the main questions is basically, do we want to support stateless NAT?
> 
> Some people ask for that sort of thing every now and then, so it
> depends on whether you want to please them. On the upside, they only
> seem to request L3 address editing and L3addrs-inside-ICMP(v6), so
> the amount of protocol handlers needed is small.

Yeah, but the l3 addresses are embedded in the protocol specific pseudo
header: There are basically two possibilities:

* add a paremeterized pseudo header update function to the payload expression.
  Requires one rule per protocol so we can set the required parameters.

* add automatic magic header updates, requires to add protocol knowledge of
  all protocols which are using this.

I'm not against supporting this per se, but I tend to go in the direction of
waiting for people that need this and describe their use cases. I don't see
any problem in adding either way later on.
