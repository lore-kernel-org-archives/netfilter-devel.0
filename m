From: "Sven-Ola Tuecke" <sven-ola@gmx.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 14:27:25 +0200
Message-ID: <201010071427.25625.sven-ola@gmx.de>
References: <201010061842.20142.sven-ola@gmx.de> <201010070940.08259.sven-ola@gmx.de> <alpine.LNX.2.01.1010070945540.29249@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:57728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753057Ab0JGM1b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:27:31 -0400
In-Reply-To: <alpine.LNX.2.01.1010070945540.29249@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey Jan,

Am Donnerstag, 7. Oktober 2010, um 09:52:26 schrieb Jan Engelhardt:

> >No RAW table in 2.4 AFAICT.
> Yeah it's 2.6.6. You should update, or let a slightly better box do the
> 6-6 mapping ;-)

Yep. I'd prefer Atheros chips if possible - but those boxes are deployed here 
and there and someone has to maintain things -> ff-firmware.sf.net

> No oopses should happen. It's just that conntrack will record two
> different connections for what is one, and the states thus don't work
> reliably.

Thanks for the estimation - but untested stuff tends to trigger mem leaks and 
whatnot. I leave the warning there. While I'm here: I wasn't aware that sme. 
has written a complete book on writing NF modules as well as maintaining a 
compat framework as well. Next time I'd try google first, then start hacking, 
Promised ;-)

// Sven-Ola
