From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [ULOGD2] UNIXSOCK plugin (v4)
Date: Thu, 14 Jan 2010 21:13:45 +0100
Message-ID: <20100114201345.GA32383@piche.inl.fr>
References: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
 <alpine.LSU.2.01.1001142056280.12046@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pierre Chifflier <chifflier@inl.fr>,
	netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:60578 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0ANUNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:13:54 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1001142056280.12046@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 14, 2010 at 08:57:27PM +0100, Jan Engelhardt wrote:
> 
> On Thursday 2010-01-14 20:41, Pierre Chifflier wrote:
> >
> >Here is an updated version of the UNIXSOCK plugin.
> >
> >Changes for v4:
> >- use structures instead of reading integers directly
> >- all structures and fields are now aligned (4 bytes)
> 
> Are there any 64-bit quantities or pointers in these structs?
> If so, this may need 8 bytes.
> 

Hi Jan,

Currently there are only uint16_t, uint32_t and strings (char*) stored
in these structs.

Alignment is defined using a constant (ALIGN_SIZE) so changing to 8
bytes shouldn't be a problem if required later.

Pierre
