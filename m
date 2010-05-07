From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_LOG: MAC address output
Date: Fri, 7 May 2010 10:02:49 +0200
Message-ID: <201005071002.49899.thomas.jarosch@intra2net.com>
References: <201005031558.09409.thomas.jarosch@intra2net.com> <alpine.LSU.2.01.1005031741100.938@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:53832 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0EGIdJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 May 2010 04:33:09 -0400
In-Reply-To: <alpine.LSU.2.01.1005031741100.938@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, 3. May 2010 17:41:47 Jan Engelhardt wrote:
> >The MAC address really looks strange if you take
> >the original data into consideration:
> >
> >
> >- Output "08:00" garbage at the end.
> 
> No garbage.
> 
> It's not the MAC address, it's the (entire) MAC header that's printed.

Thanks, Jan. So would it make sense to output a human readable
MACSRC= and MACDST=? We also don't print the raw IP header...

Cheers,
Thomas
