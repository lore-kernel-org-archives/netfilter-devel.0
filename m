From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: stable fixes for nf_conncount 4.19.x
Date: Fri, 18 Jan 2019 10:30:31 +0100
Message-ID: <2754f7f3-0ba9-5daf-2278-0fd7859e62c4@thelounge.net>
References: <20190118012413.o6daeeruqqtaqp7y@salvia>
 <20190118065707.GA10207@kroah.com> <20190118081417.GA6754@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190118081417.GA6754@kroah.com>
Content-Language: de-CH
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



Am 18.01.19 um 09:14 schrieb Greg Kroah-Hartman:
> On Fri, Jan 18, 2019 at 07:57:07AM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Jan 18, 2019 at 02:24:14AM +0100, Pablo Neira Ayuso wrote:
>>> Hi Greg,
>>>
>>> Could you cherry-pick the follow list of patches into -stable 4.19.x, please?
>>>
>>> a007232066f6 netfilter: nf_conncount: fix argument order to find_next_bit
>>> c80f10bc973a netfilter: nf_conncount: speculative garbage collection on empty lists
>>> 2f971a8f4255 netfilter: nf_conncount: move all list iterations under spinlock
>>> df4a90250976 netfilter: nf_conncount: merge lookup and add functions
>>> e8cfb372b38a netfilter: nf_conncount: restart search when nodes have been erased
>>> f7fcc98dfc2d netfilter: nf_conncount: split gc in two phases
>>> 4cd273bb91b3 netfilter: nf_conncount: don't skip eviction when age is negative
>>> c78e7818f16f netfilter: nf_conncount: replace CONNCOUNT_LOCK_SLOTS with CONNCOUNT_SLOTS
>>>
>>> conncount infrastructure is not in good shape, for more details see:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=202013
>>
>> These should also go into 4.20.y as well, right?  I don't want people to
>> experience regressions moving from 4.19 to a newer kernel release.

there is a 4.20.3 Fedora build with the patches
https://koji.fedoraproject.org/koji/taskinfo?taskID=32096601

[harry@srv-rhsoft:~]$ uname -a
Linux srv-rhsoft.rhsoft.net 4.20.3-200.rhbz1659706.fc29.x86_64 #1 SMP
Thu Jan 17 22:47:56 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

[harry@srv-rhsoft:~]$ uptime
10:29:17 up  8:40,  9 users,  load average: 0,63, 0,64, 0,82

[root@srv-rhsoft:~]$ firewall_status | grep conn
7        0     0 DROP       tcp  --  *      *       0.0.0.0/0
 0.0.0.0/0            #conn src/32 > 50
8        0     0 DROP       tcp  --  *      *       0.0.0.0/0
 0.0.0.0/0            #conn src/24 > 150

before this machine crashed within 4 hours from 4.19.0 until recent
