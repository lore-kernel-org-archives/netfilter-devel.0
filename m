From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Wed, 25 May 2011 02:58:24 +0100
Message-ID: <4DDC6240.7050701@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64995 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1EYB62 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 21:58:28 -0400
Received: by wwa36 with SMTP id 36so7941995wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 18:58:26 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Userspace changes:
>  - Restore with bitmap:port and list:set types did not work, fixed
>   
Having had the chance to test this now, I can say that it works, and 
what's more - the loading performance is much, much better - all my sets 
now load in about 2-3 seconds, while with the 4.5 version it took in 
excess of 10 minutes, completely hogging my CPU in the process. I 
haven't had the chance yet to judge the matching performance, but this 
is what I will do in the coming days.

I have found a bug, however. :-\

When I have multiple sets of different type to restore, each restore 
file normally ends with "COMMIT" statement for ipset to commit the whole 
transaction, or so I thought. If there is a mistake (syntax or any 
other) somewhere in the restore file, which prevents the restore 
process, ipset already commits everything up to that point, which I 
think is wrong.

For example, if I have this:

n privileged-ports bitmap:port range 1-1023 timeout 0
a privileged-ports 1-1023
n test-ports bitmap:port range 12770-19999 timeout 0
a test-ports 20000-30000
a test-ports 19999
n test-port bitmap:port range 29950-29950 timeout 0
a test-port 29950
COMMIT

There is an obvious error in line 4 above ("a test-ports 20000-30000" - 
this is out of the defined range for this set) - ipset should have 
aborted the whole transaction and not committed anything, but in 
practice, privileged-ports set is already registered and its members are 
already added.

Apart from the obvious error of ipset committing before the actual 
"COMMIT" has taken place, this raises another issue when I actually try 
to reload this file - I will get an error straight away as 
privileged-ports is already registered and that shouldn't be the case. 
Thought to let you know.
