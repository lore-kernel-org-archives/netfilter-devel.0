From: Kerin Millar <kerframil@gmail.com>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Thu, 08 Mar 2012 11:00:31 +0000
Message-ID: <jja3gm$16n$1@dough.gmane.org>
References: <4F50E30B.6000704@gmail.com> <20120303133002.GA18802@1984> <jitp0d$4lv$1@dough.gmane.org> <20120304110151.GA22404@1984> <jj2sjo$i8a$1@dough.gmane.org> <20120306111427.GA448@1984> <jj5eov$dr3$1@dough.gmane.org> <20120306172318.GA2282@1984> <jj63ik$u0k$1@dough.gmane.org> <jj7s24$3j2$1@dough.gmane.org> <20120308013348.GA9402@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39781 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab2CHLAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:00:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S5b5W-00084l-Ub
	for netfilter-devel@vger.kernel.org; Thu, 08 Mar 2012 12:00:50 +0100
Received: from host90-152-1-244.ipv4.regusnet.com ([90.152.1.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Mar 2012 12:00:50 +0100
Received: from kerframil by host90-152-1-244.ipv4.regusnet.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Mar 2012 12:00:50 +0100
In-Reply-To: <20120308013348.GA9402@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 08/03/2012 01:33, Pablo Neira Ayuso wrote:
> On Wed, Mar 07, 2012 at 02:41:02PM +0000, Kerin Millar wrote:

<snip>

>>> That makes sense. So, I rebooted the backup with the latest kernel
>>> build, ran my iptables script then started conntrackd. I was not able to
>>> destabilize the system through the use of your stress tool. The sequence
>>> of commands used to invoke the ct_stress tool was as follows:-
>>>
>>> 1) ct_stress 2097152
>>> 2) ct_stress 2097152
>>> 3) ct_stress 1048576
>>>
>>> There were indeed a lot of ENOMEM errors, and messages warning that the
>>> conntrack table was full with packets being dropped. Nothing surprising.
>>>
>>> I then tried my test case again. The exact sequence of commands was as
>>> follows:-
>>>
>>> 4) conntrackd -n
>>> 5) conntrackd -c
>>> 6) conntrackd -f internal
>>> 7) conntrackd -F
>>> 8) conntrackd -n
>>> 9) conntrackd -c
>>>
>>> It didn't crash after the 5th step (to my amazement) but it did after
>>> the 9th. Here's a netconsole log covering all of the above:
>>>
>>> http://paste.pocoo.org/raw/562136/
>>>
>>> The invalid opcode error was also present in the log that I provided
>>> with my first post in this thread.
>>>
>>> For some reason, I couldn't capture stdout from your ct_events tool but
>>> here's as much as I was able to copy and paste before it stopped
>>> responding completely.
>>>
>>> 2100000 events received (2 new, 1048702 destroy)
>>> 2110000 events received (2 new, 1048706 destroy)
>>> 2120000 events received (2 new, 1048713 destroy)
>>> 2130000 events received (2 new, 1048722 destroy)
>>> 2140000 events received (2 new, 1048735 destroy)
>>> 2150000 events received (2 new, 1048748 destroy)
>>> 2160000 events received (2 new, 1048776 destroy)
>>> 2170000 events received (2 new, 1048797 destroy)
>>> 2180000 events received (2 new, 1048830 destroy)
>>> 2190000 events received (2 new, 1048872 destroy)
>>> 2200000 events received (2 new, 1048909 destroy)
>>> 2210000 events received (2 new, 1048945 destroy)
>>> 2220000 events received (2 new, 1048985 destroy)
>>> 2230000 events received (2 new, 1049039 destroy)
>>> 2240000 events received (2 new, 1049102 destroy)
>>> 2250000 events received (2 new, 1049170 destroy)
>>> 2260000 events received (2 new, 1049238 destroy)
>>> 2270000 events received (2 new, 1049292 destroy)
>>> 2280000 events received (2 new, 1049347 destroy)
>>> 2290000 events received (2 new, 1049423 destroy)
>>> 2300000 events received (2 new, 1049490 destroy)
>>> 2310000 events received (2 new, 1049563 destroy)
>>> 2320000 events received (2 new, 1049646 destroy)
>>> 2330000 events received (2 new, 1049739 destroy)
>>> 2340000 events received (2 new, 1049819 destroy)
>>> 2350000 events received (2 new, 1049932 destroy)
>>> 2360000 events received (2 new, 1050040 destroy)
>>> 2370000 events received (2 new, 1050153 destroy)
>>> 2380000 events received (2 new, 1050293 destroy)
>>> 2390000 events received (2 new, 1050405 destroy)
>>> 2400000 events received (2 new, 1050535 destroy)
>>> 2410000 events received (2 new, 1050661 destroy)
>>> 2420000 events received (2 new, 1050786 destroy)
>>> 2430000 events received (2 new, 1050937 destroy)
>>> 2440000 events received (2 new, 1051085 destroy)
>>> 2450000 events received (2 new, 1051226 destroy)
>>> 2460000 events received (2 new, 1051378 destroy)
>>> 2470000 events received (2 new, 1051542 destroy)
>>> 2480000 events received (2 new, 1051693 destroy)
>>> 2490000 events received (2 new, 1051852 destroy)
>>> 2500000 events received (2 new, 1052008 destroy)
>>> 2510000 events received (2 new, 1052185 destroy)
>>> 2520000 events received (2 new, 1052373 destroy)
>>> 2530000 events received (2 new, 1052569 destroy)
>>> 2540000 events received (2 new, 1052770 destroy)
>>> 2550000 events received (2 new, 1052978 destroy)
>>
>> Just to add that I ran a more extensive stress test on the backup,
>> like so ...
>>
>> for x in $(seq 1 100); do ct_stress 1048576; sleep $(( $RANDOM % 60 )); done
>
> I guess you're running ct_events_reliable as well. Lauching several
> ct_stress at the same time is also interesting.

The ct_events (conntrack_events.c) program was running throughout and 
"NetlinkEventsReliable On" remains defined in conntrackd.conf. I will 
try running ct_stress concurrently.

>
>> It remained stable throughout. I notice that there's an option to
>> dump the cache in XML format. I wonder if it be useful if I were to
>> provide such a dump, having synced with the master? Assuming that
>> there's a way to inject the contents, perhaps you could reproduce
>> the issue also.
>
> I've been launching the user-space stress tests but I was not abled to
> reproduce the problem that you reported so far.
>
> I'd need to know if the problem that you reported is easy to
> reproduce in your setup or, it looks more like a race condition.
> Moreover, I need to know if there was some traffic circulating
> through the backup or no traffic at all.

Indeed, I can reproduce it so easily and consistently that I've now lost 
track of the amount of times I've had to hard reboot this machine. To 
recap: I boot the slave with 3.3-rc5 (now featuring the three patches 
you asked me to apply). My iptables ruleset is loaded and conntrackd is 
started. At that point, the stats look like this:-

# conntrackd -s
cache internal:
current active connections:              109
connections created:                     175    failed:            0
connections updated:                       0    failed:            0
connections destroyed:                    66    failed:            0

cache external:
current active connections:             3676
connections created:                    3688    failed:            0
connections updated:                       4    failed:            0
connections destroyed:                    12    failed:            0

traffic processed:
                    0 Bytes                         0 Pckts

UDP traffic (active device=eth2):
                 4360 Bytes sent               570188 Bytes recv
                   91 Pckts sent                 6681 Pckts recv
                    0 Error send                    0 Error recv

message tracking:
                    0 Malformed msgs                    0 Lost msgs

NOTE: if left alone, external cache usage grows steadily - as expected 
due to the master handling new connections to our busy load 
balance/appserver farm.

Next, rather than spend the time waiting for the backup to catch up, I 
explicitly synchronize with the master.

# conntrackd -n
# conntrackd -s
cache internal:
current active connections:                5
connections created:                     179    failed:            0
connections updated:                       0    failed:            0
connections destroyed:                   174    failed:            0

cache external:
current active connections:          1295640
connections created:                 1351838    failed:            0
connections updated:                      26    failed:            0
connections destroyed:                 56198    failed:            0

traffic processed:
                    0 Bytes                         0 Pckts

UDP traffic (active device=eth2):
               139384 Bytes sent            112306776 Bytes recv
                 1054 Pckts sent               135073 Pckts recv
                    0 Error send                    0 Error recv

message tracking:
                    0 Malformed msgs               175170 Lost msgs

The number of state entries in the external cache is now in line with 
the master. Finally, I commit.

# conntrackd -c

What happens next is one of two things ...

a) a seemingly never-ending series of hard lockups occur
b) it panics with "not syncing: Fatal exception in interrupt"

Scenario (a) seems to be more frequent but, either way, it happens 
virtually every single time. I think I've had no more than *two* 
occasions where conntrackd -c returned to prompt in dozens upon dozens 
of tests and, even then, the system didn't survive a second invocation 
of conntrackd -c. In all cases, I have to hard reboot the machine. 
Netconsole logs for both of these outcomes have been provided in 
previous posts. Ergo, it's entirely reproducible here.

There are absolutely no signs of instability with the system except for 
when state is being committed. Indeed, I first became aware of this 
situation upon simulating a genuine failover scenario. That is, I shut 
down the master, ucarp migrated the VIPs and instructed conntrackd to 
commit state. Then it died. Since that first time, I deactivated ucarp 
entirely and have easily reproduced the issue by running conntrackd -c 
manually.

Cheers,

--Kerin

