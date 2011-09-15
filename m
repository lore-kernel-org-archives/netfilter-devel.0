From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.9.1 released
Date: Thu, 15 Sep 2011 10:51:13 +0100
Message-ID: <4E71CA91.5080402@googlemail.com>
References: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu> <4E713E0F.1050403@googlemail.com> <alpine.DEB.2.00.1109150846290.5001@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1IOJvX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:51:23 -0400
In-Reply-To: <alpine.DEB.2.00.1109150846290.5001@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I suppose you are trying to compile the kernel part of the package 
> directly. What should be done is as follows:
>   
No, actually, I am building ipset as part of the kernel built - I patch 
the sources (i.e. "copy" most of the files in kernel/include and 
kernel/net to the kernel tree) and then (trying to) build the kernel 
itself in the same way as I did with 6.8. The difference this time is 
that I've got the above errors. These occur during the kernel built - 
sorry, I should have made this clear.

