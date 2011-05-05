From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: Feature request: ip_set for non-modular kernel
Date: Thu, 05 May 2011 14:49:37 +0100
Message-ID: <4DC2AAF1.6000301@googlemail.com>
References: <4DC29AFF.5060901@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1EENtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2011 09:49:45 -0400
Received: by wwa36 with SMTP id 36so2382775wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 May 2011 06:49:44 -0700 (PDT)
In-Reply-To: <4DC29AFF.5060901@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Hi, Love the ip_set features - any chance that you might provide the
> code (or possibly just instructions?) to build into the kernel in a
> non-modular fashion? (for 2.6.38 and earlier)
>   
I was able to successfully achieve just that with version 4.5 and kernel 
2.6.35 (kernel compiled from source, of course). If you have ipset 4.5 
there is a nifty script called patch_kernel in the kernel/ directory 
which does the donkey work for you - i.e. copying the necessary files to 
the kernel source directory and adjust the appropriate kernel Kbuild and 
Makefile(s).

What is left to be done by you then is to run "make oldconfig" (or amend 
the ipset kernel options manually, if you wish) and adjust the ipset 
kernel options so that all ipset files are included in the kernel, not 
as modules (in other words, set all ipset-related kernel options to "y" 
as oppose to "m").

In version 6 and above, the job is a tad more difficult as I am not sure 
you can build the ipset objects as part of the kernel - I have 
successfully built them as modules (as part of the kernel compilation), 
but have not tried to include them as part of the kernel itself - I am 
waiting for Jozsef to fix the bug I found in v6.3 and I will then 
upgrade all my systems to that version (I am still on 4.5 at present). 
Good luck!

