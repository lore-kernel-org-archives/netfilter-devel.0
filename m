From: Kerin Millar <kerframil@gmail.com>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Mon, 05 Mar 2012 17:19:49 +0000
Message-ID: <jj2sjo$i8a$1@dough.gmane.org>
References: <4F50E30B.6000704@gmail.com> <20120303133002.GA18802@1984> <jitp0d$4lv$1@dough.gmane.org> <20120304110151.GA22404@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34593 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab2CERUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:20:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S4bZp-0006gQ-Oh
	for netfilter-devel@vger.kernel.org; Mon, 05 Mar 2012 18:20:01 +0100
Received: from cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com ([94.170.82.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Mar 2012 18:20:01 +0100
Received: from kerframil by cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Mar 2012 18:20:01 +0100
In-Reply-To: <20120304110151.GA22404@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 04/03/2012 11:01, Pablo Neira Ayuso wrote:
> Hi Kerin,
>
> On Sat, Mar 03, 2012 at 06:47:27PM +0000, Kerin Millar wrote:
>> Hi,
>>
>> On 03/03/2012 13:30, Pablo Neira Ayuso wrote:
>>> I just posted another patch to the ML that is a relative fix to
>>> Jozsef's patch. You have to apply that as well.
>>
>> I've now tested 3.3-rc5 with the addition of the above mentioned
>> follow-on patch. The behaviour during conntrackd -c execution is
>> clearly much improved - in so far as it doesn't generate much noise
>> - but the crash that follows remains. Here's a netconsole capture:-
>>
>> http://paste.pocoo.org/raw/560439/
>
> Great to know :-).

I apologize but I think I may have led you astray on the nf_nat issue. 
At the time of submitting my original report, I now believe that the 
nf_nat module wasn't loaded prior to starting conntrackd, although it 
was definitely available. For all tests that followed, however, I am 
entirely certain the the nf_nat module was loaded in advance. The upshot 
is that my claim that things had improved may have been premature; I 
need to specifically test under both circumstances to be sure that 
things are improving. That is, both with and without the module loaded 
in advance.

Following my own advice then, I first tried going through my test case 
*without* loading nf_nat in advance. Alas, conntrackd -c triggered hard 
lockups and didn't return to prompt. Here are the results:-

http://paste.pocoo.org/raw/561350/

In case it matters, the existing ssh session continued to respond to 
input but I was no longer able to initiate any new sessions.

>
> Regarding your previous email, I'm sorry, by reading your email I
> thought you were using 2.6.32 which was not the case, your
> configuration is perfectly reasonable.
>
> It seems we still have problems regarding early_drop, but this time
> with reliable event delivery enabled (15 seconds is the time that
> is required to retry sending the destroy event).
>
> If you can test the following patch, I'll appreciate.

Gladly. I applied the patch to my 3.3-rc5 tree, which is still carrying 
the two patches discussed earlier in the thread. I then went through my 
test case under normal circumstances i.e. all firewall rules in place, 
nf_nat confirmed present before conntrackd etc. Again, conntrackd -c did 
not return to prompt. Here are the results:-

http://paste.pocoo.org/raw/561354/

Well, at least there was no oops this time. I should also add that the 
patch was present for both of the tests mentioned in this email.

---
Incidentally, I found out why the internal cache on the master was 
filling up to capacity. It was apparently due to the use of "iptables -I 
PREROUTING -t raw -j CT --ctevents assured". Perhaps I'm missing 
something but doesn't this stop events such as new and destroy from 
being propagated? An inspection with conntrack -E suggests so. Once I 
removed the above rule, I could see destroy events being propagated and 
the number of active connections in the cache no longer exceeded my 
chosen limit of 2097152 ...

# conntrack -S | head -n1; conntrackd -s | head -n2
entries                 725826
cache internal:
current active connections:          1409472

Whatever the case, I'm quite happy to go without this rule as these 
systems are coping fine with the load incurred by conntrackd.

Cheers,

--Kerin

