From: Nick Pasich <NewsLetters@NickAndBarb.net>
Subject: Re: iptables + geoip
Date: Mon, 11 Feb 2008 17:04:09 -0800
Message-ID: <20080212010409.GA19332@69.17.112.251>
References: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Robert Bruce <rob@thirddimensiondesign.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dsl017-112-251.lax1.dsl.speakeasy.net ([69.17.112.251]:40679
	"EHLO NickAndBarb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158AbYBLBJ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:09:56 -0500
Content-Disposition: inline
In-Reply-To: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I got the same thing using iptables 1.4.0.

I used patch geoip-match-2.6.22.patch.gz that I've 
been using for quite awhile ... there is no other patch available.

My kernel version is 2.6.23.13

I went back to iptables 1.3.8 and everything is fine.

             ---( Nick )---



On Mon, Feb 11, 2008 at 08:30:56AM -0000, Robert Bruce wrote:
> Hello
> 
> I tried to send this to the developers of geoip, but the email got
> returned to me. I can't put this on bugzilla as it is down at the
> moment...
> 
> Original Email:
> 
> Hi Guys
> 
> I've just tried to install geoip with iptables 1.4.0, everything is fine
> until I try to add a rule which uses the geoip module and I get a
> Segmentation fault. So I did some digging, compiled with -g for gdb and
> found that the problem is on line 229 as match is passed in with an
> address to 0x0.
> 
> I dunno how to fix that though..
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

