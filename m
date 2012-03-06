From: Kerin Millar <kerframil@gmail.com>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Tue, 06 Mar 2012 22:37:04 +0000
Message-ID: <jj63ik$u0k$1@dough.gmane.org>
References: <4F50E30B.6000704@gmail.com> <20120303133002.GA18802@1984> <jitp0d$4lv$1@dough.gmane.org> <20120304110151.GA22404@1984> <jj2sjo$i8a$1@dough.gmane.org> <20120306111427.GA448@1984> <jj5eov$dr3$1@dough.gmane.org> <20120306172318.GA2282@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43064 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab2CFWhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:37:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S530S-0001O8-EH
	for netfilter-devel@vger.kernel.org; Tue, 06 Mar 2012 23:37:20 +0100
Received: from cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com ([94.170.82.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Mar 2012 23:37:20 +0100
Received: from kerframil by cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Mar 2012 23:37:20 +0100
In-Reply-To: <20120306172318.GA2282@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 06/03/2012 17:23, Pablo Neira Ayuso wrote:

<snip>

>>> I've been using the following tools that you can find enclosed to this
>>> email, they are much more simple than conntrackd but, they do the same
>>> in essence:
>>>
>>> * conntrack_stress.c
>>> * conntrack_events.c
>>>
>>> gcc -lnetfilter_conntrack conntrack_stress.c -o ct_stress
>>> gcc -lnetfilter_conntrack conntrack_events.c -o ct_events
>>>
>>> Then, to listen to events with reliable event delivery enabled:
>>>
>>> # ./ct_events&
>>>
>>> And to create loads of flow entries in ASSURED state:
>>>
>>> # ./ct_stress 65535 # that's my ct table size in my laptop
>>>
>>> You'll hit ENOMEM errors at some point, that's fine, but no oops or
>>> lockups happen here.
>>>
>>> I have pushed this tools to the qa/ directory under
>>> libnetfilter_conntrack:
>>>
>>> commit 94e75add9867fb6f0e05e73b23f723f139da829e
>>> Author: Pablo Neira Ayuso<pablo@netfilter.org>
>>> Date:   Tue Mar 6 12:10:55 2012 +0100
>>>
>>>      qa: add some stress tools to test conntrack via ctnetlink
>>>
>>> (BTW, ct_stress may disrupt your network connection since the table
>>> gets filled. You can use conntrack -F to get the ct table empty again).
>>>
>>
>> Sorry if this is a silly question but should conntrackd be running
>> while I conduct this stress test? If so, is there any danger of the
>> master becoming unstable? I must ask because, if the stability of
>> the master is compromised, I will be in big trouble ;)
>
> If you run this in the backup, conntrackd will spam the master with
> lots of new flows in the external cache. That shouldn't be a problem
> (just a bit of extra load invested in the replication).
>
> But if you run this in the master, my test will fill the ct table
> with lots of assured flows. Thus, packets that belong new flows will
> be likely dropped in that node.

That makes sense. So, I rebooted the backup with the latest kernel 
build, ran my iptables script then started conntrackd. I was not able to 
destabilize the system through the use of your stress tool. The sequence 
of commands used to invoke the ct_stress tool was as follows:-

1) ct_stress 2097152
2) ct_stress 2097152
3) ct_stress 1048576

There were indeed a lot of ENOMEM errors, and messages warning that the 
conntrack table was full with packets being dropped. Nothing surprising.

I then tried my test case again. The exact sequence of commands was as 
follows:-

4) conntrackd -n
5) conntrackd -c
6) conntrackd -f internal
7) conntrackd -F
8) conntrackd -n
9) conntrackd -c

It didn't crash after the 5th step (to my amazement) but it did after 
the 9th. Here's a netconsole log covering all of the above:

http://paste.pocoo.org/raw/562136/

The invalid opcode error was also present in the log that I provided 
with my first post in this thread.

For some reason, I couldn't capture stdout from your ct_events tool but 
here's as much as I was able to copy and paste before it stopped 
responding completely.

2100000 events received (2 new, 1048702 destroy)
2110000 events received (2 new, 1048706 destroy)
2120000 events received (2 new, 1048713 destroy)
2130000 events received (2 new, 1048722 destroy)
2140000 events received (2 new, 1048735 destroy)
2150000 events received (2 new, 1048748 destroy)
2160000 events received (2 new, 1048776 destroy)
2170000 events received (2 new, 1048797 destroy)
2180000 events received (2 new, 1048830 destroy)
2190000 events received (2 new, 1048872 destroy)
2200000 events received (2 new, 1048909 destroy)
2210000 events received (2 new, 1048945 destroy)
2220000 events received (2 new, 1048985 destroy)
2230000 events received (2 new, 1049039 destroy)
2240000 events received (2 new, 1049102 destroy)
2250000 events received (2 new, 1049170 destroy)
2260000 events received (2 new, 1049238 destroy)
2270000 events received (2 new, 1049292 destroy)
2280000 events received (2 new, 1049347 destroy)
2290000 events received (2 new, 1049423 destroy)
2300000 events received (2 new, 1049490 destroy)
2310000 events received (2 new, 1049563 destroy)
2320000 events received (2 new, 1049646 destroy)
2330000 events received (2 new, 1049739 destroy)
2340000 events received (2 new, 1049819 destroy)
2350000 events received (2 new, 1049932 destroy)
2360000 events received (2 new, 1050040 destroy)
2370000 events received (2 new, 1050153 destroy)
2380000 events received (2 new, 1050293 destroy)
2390000 events received (2 new, 1050405 destroy)
2400000 events received (2 new, 1050535 destroy)
2410000 events received (2 new, 1050661 destroy)
2420000 events received (2 new, 1050786 destroy)
2430000 events received (2 new, 1050937 destroy)
2440000 events received (2 new, 1051085 destroy)
2450000 events received (2 new, 1051226 destroy)
2460000 events received (2 new, 1051378 destroy)
2470000 events received (2 new, 1051542 destroy)
2480000 events received (2 new, 1051693 destroy)
2490000 events received (2 new, 1051852 destroy)
2500000 events received (2 new, 1052008 destroy)
2510000 events received (2 new, 1052185 destroy)
2520000 events received (2 new, 1052373 destroy)
2530000 events received (2 new, 1052569 destroy)
2540000 events received (2 new, 1052770 destroy)
2550000 events received (2 new, 1052978 destroy)

Cheers,

--Kerin

