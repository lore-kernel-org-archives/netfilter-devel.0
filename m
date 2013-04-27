From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 21:07:51 +0100
Message-ID: <517C3017.8090803@googlemail.com>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu> <517BCA9A.3080602@googlemail.com> <alpine.DEB.2.00.1304272042070.1511@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37197 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3D0UH5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 16:07:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id a12so2743118wgh.11
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2013 13:07:56 -0700 (PDT)
Received: from [10.68.68.173] (cpc2-gill1-0-0-cust218.basl.cable.virginmedia.com. [82.34.56.219])
        by mx.google.com with ESMTPSA id ge7sm12016456wib.6.2013.04.27.13.07.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 27 Apr 2013 13:07:54 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1304272042070.1511@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
>> Jozsef, are these features already supported in userspace or are you going to
>> release a separate version?
>>     
>
> It's already supported in userspace in the main branch of the git tree.
Got it, thanks Jozsef, though I can't see any updates to the ipset 
branch of the netfilter.org tree (https://git.netfilter.org/ipset) - 
last update is showing 13 days ago.

>  As the patch for the userspace part of the set match is committed in the 
> iptables git tree, there'll come the new ipset release.
>   
OK, good to know. I see that with the new patches you have expanded the 
ipset data structure, which is also good - I could now fit all of my 
"custom" changes without resorting to dark-art gimmicks as I did up 
until now.
