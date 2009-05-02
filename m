From: pud <pud@subnet666.de>
Subject: Re: IMQ bug: kernel reboot immediately
Date: Sat, 2 May 2009 14:03:12 +0200
Message-ID: <20090502120312.GA3756@safeTpin.homeunix.org>
References: <200904222327392967897@gmail.com>
Reply-To: pud@subnet666.de
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.qsc.de ([213.148.130.14]:52156 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbZEBM0T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2009 08:26:19 -0400
Received: from safetpin.homeunix.org (port-87-234-80-215.dynamic.qsc.de [87.234.80.215])
	by mx02.qsc.de (Postfix) with ESMTP id 55A2416C010E
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2009 14:03:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <200904222327392967897@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 22 Apr 2009, Y. D. wrote:

> Is IMQ still maintained? I am using IMQ to shape ingress traffic.
> But the application is a streaming server (VLC). However, the kernel
> reboots immediately as quick as can hardly been seen what is
> wrong with it.

wrong list i guess :)
latest working patches that were posted on imq-list are available here:
http://www.student.oulu.fi/~jukivili/imq/

i know that esp. netdev (sorry, i'm not subscribed there)
folks don't like imq so much,
but because documentation for ifb and related stuff really sucks
(for users) a lot of people stick to imq, even if ifb might
be a better solution, technically
[really, for all (a)dsl users it's no alternative, yet]

but... if anyone wants to have a look at that patches, give some
(constructive) feedback, you're welcome
i'll forward them to imq list, if you like


=;p/ud aka nerdpunk

-- 
gpg-key #C3B04767
