From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Fri, 30 Oct 2009 17:07:05 +0100
Message-ID: <200910301707.05490.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910271149.10969.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910281840390.15948@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:40182 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbZJ3QHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:07:03 -0400
In-Reply-To: <alpine.LSU.2.00.0910281840390.15948@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, 28. October 2009 18:51:14 Jan Engelhardt wrote:
> >I'm starting to get my mind ready for endian issues :)
> >The "net_OR_mask" is in host order if I understood it correctly,
> >so shouldn't this read "(b << 8)"?
> 
> Yes it should be <<8.

Hehe :)

> Besides, "the 8 bit" comment is confusing, because both CIDR/8 and
> CIDR/24 have eight bits either way - just one has eight 1s, one has
> eight 0s.

True that. Didn't came up with a better description back
in the days when I wrote it.

> I am in the process of annotating the entire source with the BE
> markers and I am already getting into situations where I think
> "there's more bswapping amiss"

One more thing came to my mind: The new code transfers the data in
network order from kernel to userspace. This will break existing 
applications which make use of libipt_ACCOUNT like the included "iptaccount"
tool or other applications. We should keep it in host order if possible
or transform it inside libipt_ACCOUNT. Even if we transform it,
it will break systems without updated libipt_ACCOUNT versions.

What do you think?

Cheers,
Thomas
