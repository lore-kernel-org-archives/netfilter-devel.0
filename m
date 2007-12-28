From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Fri, 28 Dec 2007 17:38:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: gpf <gpf@simm.ru>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51136 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbXL1QiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:38:11 -0500
In-Reply-To: <477520C3.8040501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 28 2007 17:13, Patrick McHardy wrote:
>> > >
>> > > [root@ns bind] iptables -L quot |grep devel
>> > > RETURN     0    --  anywhere             developer.simm.ru   quota:
>> > > 226620450 bytes
>> > > [root@ns bind] dpkg -l |grep iptables
>> > > ii  iptables                   1.3.6.0debian1-5
>> > >   
>> > >       
>> > The quota extension in old iptables releases is incompatible with the
>> > version merged upstream.
>>
>> I am seeing this too on 2.6.23.10 with iptables-1.4.0svn7097.
>> No incompatibilities obvious to me, both kernel and iptables use
>> the same xt_quota.h.
>
> Gpf's report didn't include an actual description of the problem, so
> I can only assume its an incorrect value of the quota. What exactly
> are the effects you're seeing?
>

To begin with:

	ssh root@somebox

when logged in:

	iptables -I OUTPUT -m quota --quota 1234567

as you do more actions over the interactive ssh session, the quota
will obviously decrease -- after all, that is what it is supposed
to do. Enter

	iptables -nvL OUTPUT

should reduce the quota by some 50-60 bytes per packet (and typing the 
iptables command costs some bytes), but as you 
repeatedly call iptables, the quota fluctuates around 1234567.

What one can see is that the packet counter (1st column) increases while 
the quota has problems.

17:38 ccgmbh:~ # iptables -nvL | grep quota
  155 35709            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1234567 bytes
17:38 ccgmbh:~ # iptables -nvL | grep quota
  163 36609            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1234567 bytes
17:38 ccgmbh:~ # iptables -nvL | grep quota
  171 37509            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1197058 bytes
17:38 ccgmbh:~ # iptables -nvL | grep quota
  179 38409            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1234567 bytes

What is interesting to note is that if we do away with all "wrong" 
results, then it "works":

17:39 ccgmbh:~ # while :; do iptables -nvL | grep quota; done | grep -v 1234567
...
  830  118K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1116680 bytes
  832  118K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1116399 bytes
  834  118K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1116150 bytes
  834  118K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1116150 bytes
  838  119K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           quota: 1115684 bytes
...

Want to know what I believe? That r->master = r in the source code is 
redundant and/or does not solve the problem its comment says.

/* For SMP, we only want to use one set of counters. */

And my bigtime question would be: where is the other counter actually? 
struct xt_quota_info only has one counter! Does netfilter secretly 
allocate matchinfos per-cpu?
