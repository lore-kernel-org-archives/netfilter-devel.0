From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: nomatch in bitmap:* sets
Date: Mon, 09 Apr 2012 22:58:49 +0100
Message-ID: <4F835B99.8060901@googlemail.com>
References: <4F81A7E5.3040400@googlemail.com> <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu> <4F82110E.70100@googlemail.com> <alpine.DEB.2.00.1204092031110.6233@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63926 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2DIV64 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:58:56 -0400
Received: by wibhr17 with SMTP id hr17so2546468wib.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Apr 2012 14:58:55 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1204092031110.6233@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> That's equivalent with
>
> n test-ports bitmap:port range 1-1023 timeout 0
> a test-ports 1-1023
> d test-ports 21
> d test-ports 80
> d test-ports 119
> d test-ports 443
>   
It is indeed! That's something I did not know about! The "delete" 
command wasn't acceptable in ipset restore file before (in all honesty I 
did try this back in 4.x and gave up after it was rejected). Which 
version of ipset was this introduced into?

