From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: patch in bugzilla
Date: Sat, 3 Mar 2012 14:39:15 +0100
Message-ID: <20120303133915.GA18857@1984>
References: <CAO88JF9FcBkjEs345hK4bOhQa1q-RuckkrLN9SKUUt3cWaLJKw@mail.gmail.com>
 <alpine.LNX.2.01.1202281409020.10284@frira.zrqbmnf.qr>
 <20120229125052.GA1115@1984>
 <20120229232739.GB3817@1984>
 <CAO88JF-=PTq2ZXaNWhE6mLKZY96y_fqCqxetNy-6h-Dwv3Ph3Q@mail.gmail.com>
 <20120302164209.GA13687@1984>
 <alpine.LNX.2.01.1203022123440.6223@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonh Wendell <jonh.wendell@vexcorp.com>,
	netfilter-devel@vger.kernel.org,
	Jesper Sander Lindgren <jsp@comx.dk>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab2CCNjR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 08:39:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1203022123440.6223@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 02, 2012 at 09:28:10PM +0100, Jan Engelhardt wrote:
> >Your patch will break other programs made by people like you that use
> >libiptc.
> >
> >Jan?
> 
> iptc is the last thing I want on my todo list :)

Me too :-)

> Talk to Jasper, who has more or less an actual overview about
> what is and could be using libiptc externally.
> Meanwhile see this untested proposal of mine..

Jesper, we're having this discussion again. I don't mind about
applying this patch as a workaround for this case but I don't like the
idea of keep adding function2() things in the future. libiptc has been
broken many times in the past.

Let us know.
