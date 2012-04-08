From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: nomatch in bitmap:* sets
Date: Sun, 08 Apr 2012 23:28:30 +0100
Message-ID: <4F82110E.70100@googlemail.com>
References: <4F81A7E5.3040400@googlemail.com> <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52162 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2DHW2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:28:36 -0400
Received: by wejx9 with SMTP id x9so2343724wej.19
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Apr 2012 15:28:35 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Currently only hash:* sets have the "nomatch" feature. Could this be 
>> extended to bitmap:* sets as well?
>>     
>
> Actually, hash:*net* types have the "nomatch" feature. How would it make 
> sense to add it to the bitmap:* types too?
>   
I was thinking along the lines of this:

1. bitmap:port - currently, if I want to exclude specific ports from a 
given range (say ports 21,80,119,443 from ports range 1-1023) then I 
have to do the following:
n test-ports bitmap:port range 1-1023 timeout 0
a test-ports 1-20
a test-ports 22-79
a test-ports 81-118
a test-ports 120-442
a test-ports 444-1023

Very inconvenient and it is not immediately obvious which ports have 
been excluded from that range. By doing something like this:
n test-ports bitmap:port range 1-1023 timeout 0
a test-ports 1-1023
a test-ports 21 nomatch
a test-ports 80 nomatch
a test-ports 119 nomatch
a test-ports 443 nomatch

it is much more clearer what is going on.

2. bitmap:ip - same as above really: If I want to exclude a particular 
IP addresses from a given range (say 10.1.1.3, 10.1.1.9 and 10.1.1.14 
from 10.1.1.0/24) I have to do almost the same as with bitmap:port set 
above:
n test-bitmap-net bitmap:ip range 10.1.1.0/24 timeout 0
a test-bitmap-net 10.1.1.0-10.1.1.2
a test-bitmap-net 10.1.1.4-10.1.1.8
a test-bitmap-net 10.1.1.10-10.1.1.13
a test-bitmap-net 10.1.1.15-10.1.1.255

Again, it is not immediately obvious what has been excluded. By doing 
something like the following:
n test-bitmap-net bitmap:ip range 10.1.1.0/24 timeout 0
a test-bitmap-net 10.1.1.0/24
a test-bitmap-net 10.1.1.3 nomatch
a test-bitmap-net 10.1.1.9 nomatch
a test-bitmap-net 10.1.1.14 nomatch

that it is much more clearer.
