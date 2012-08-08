From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 8 Aug 2012 16:15:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr>
References: <1344428741.4763.21.camel@localhost>  <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr> <1344433984.4763.28.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:51220 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab2HHOPY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:15:24 -0400
In-Reply-To: <1344433984.4763.28.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-08-08 15:53, Arif Hossain wrote:
>On Wed, 2012-08-08 at 15:41 +0200, Jan Engelhardt wrote:
>> On Wednesday 2012-08-08 14:25, Arif Hossain wrote:
><snip>
>> Complicated? No, not at all. http://inai.de/2008/02/24
>> Heavyweight? Neither. The RSS is ~5 MB, most of which is pretty much
>> glibc anyway.
>
>If clients are mainly embedded devices, and most of the time, all we can
>do is to install a software on them, then is it feasible to use IPSEC?

You can probably even use IPsec without StrongSWAN, if you manage to 
knit together the pieces using `ip xfrm state` and `ip xfrm policy`.


>Just for an example, we used tls for only the initial session
>establishment, not the original data, and it proved very inefficient so
>we had to abandon the thing completely.

So perhaps you did something really wrong?
