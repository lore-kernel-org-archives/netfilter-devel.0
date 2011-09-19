From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ipset-6.9.1: 3.0.4 kernel tests failure
Date: Mon, 19 Sep 2011 14:41:14 +0100
Message-ID: <4E77467A.6070500@googlemail.com>
References: <1316438977.7764.6.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1ISNlV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:41:21 -0400
Received: by wwf22 with SMTP id 22so7996832wwf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2011 06:41:20 -0700 (PDT)
In-Reply-To: <1316438977.7764.6.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> BTW, in general is it better to use in-kernel modules or kernel modules
> bundled with ipset? Personally I'd better pushed required patches into
> our kernels and suggested users to use them, but where it's better to
> pull such patches from?
>   
My own personal preference since last year has been to integrate the 
kernel modules as part of the kernel built and then use modified .spec 
file to build ipset (the userspace executable).

There are a couple of reasons for this, not least because every time I 
need to build/change the kernel (and that happens more often than 
building ipset - at least in my case, as I am testing different things 
in the kernel for different machines at one time) I have to reinstall 
the buildsys packages (I use Fedora) and tailor them for the new kernel 
in order to allow ipset kernel modules to be built, then rebuild ipset 
(userspace) as well - too much hassle.

What I do to avoid all that is create a patch based on the ipset kernel 
module sources as well as the ipset Kconfig/Kbuild menu options and then 
integrate that patch as part of the kernel built. That has never failed 
except the last time with the above version of ipset, but Jozsef 
provided a quick work-around and I am happy with it - it works!
