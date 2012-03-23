From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ipset nomatch not showing
Date: Fri, 23 Mar 2012 20:06:50 +0000
Message-ID: <4F6CD7DA.1080301@googlemail.com>
References: <4F6C7368.3040905@googlemail.com> <alpine.DEB.2.00.1203232057030.20864@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49774 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839Ab2CWUGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:06:54 -0400
Received: by wibhr17 with SMTP id hr17so2109779wib.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 13:06:52 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1203232057030.20864@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I can't reproduce this. What is your kernel version,
3.2

>  ipset version
ipset v6.11, protocol version: 6

>  and how 
> did you install the ipset kernel modules: from the ipset package or the 
> modules came together with the kernel.
>   
Used the kernel modules, but applied a patch to bring them up to v6.11 
level (can include that patch if you need it - just let me know). ipset 
executable has been built separately, using the v6.11 sources as released.

> Thanks, I correct the help text messages.
>   
Pleasure!

