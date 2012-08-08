From: Arif Hossain <aftnix@gmail.com>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 08 Aug 2012 19:53:04 +0600
Message-ID: <1344433984.4763.28.camel@localhost>
References: <1344428741.4763.21.camel@localhost>
	 <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61890 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab2HHODz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:03:55 -0400
In-Reply-To: <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-08-08 at 15:41 +0200, Jan Engelhardt wrote:
> On Wednesday 2012-08-08 14:25, Arif Hossain wrote:
<snip>
> Complicated? No, not at all. http://inai.de/2008/02/24
> Heavyweight? Neither. The RSS is ~5 MB, most of which is pretty much
> glibc anyway.
> 

If clients are mainly embedded devices, and most of the time, all we can
do is to install a software on them, then is it feasible to use IPSEC? 

At this moment we are including the cryptography in the software we
provide for them, and many low end mobile devices has severe memory
limitation. 

Just for an example, we used tls for only the initial session
establishment, not the original data, and it proved very inefficient so
we had to abandon the thing completely.

The limitations of clinet devices forces us to use a very lightweight
and easy to implement (so that we can implement it in the limited
environment present in client devices) algorithms.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


