From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 23:30:40 +0100
Message-ID: <20130319223040.GG13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141605.158831637@eitzenberger.org>
 <20130319.102620.2063759629502166169.davem@davemloft.net>
 <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
 <20130319213424.GE13505@imap.eitzenberger.org>
 <alpine.LNX.2.01.1303192249170.688@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940Ab3CSWao (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:30:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1303192249170.688@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> >having read through the webpage - and using 'goto' for error handling
> >in own code quite often - I don't see why your code above should be
> >more readable.
> 
> It was only coincidental that the webpage also mentioned goto.
> The general idea (and google keywords) was called something like
> "Else Considered Harmful", and the lesson consisted of early
> exclusion of simple cases from the flow of the remainder of the
> function. Perhaps to illustrate it better:
> 
> 	list_for_each_entry(thing, &yourlist, anchor) {
> 		if (thing->property == MAGIC) {
> 			do_stuff;
> 		}
> 	}
> 
> =>
> 
> 	list_for_each_entry(thing, &yourlist, anchor) {
> 		if (thing->property != MAGIC)
> 			continue;
> 		do_stuff;
> 	}
> 
> Code may become more readable as one gains one level of indent and
> have some more freedom in arranging the giblets inside the do_stuff parts.

Ack.
