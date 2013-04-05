From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Fri, 05 Apr 2013 20:10:36 +0100
Message-ID: <515F21AC.3080504@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost> <512E7331.10304@googlemail.com> <515DE487.9020209@googlemail.com> <alpine.DEB.2.00.1304042341530.24744@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:57907 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162510Ab3DETKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:10:43 -0400
Received: by mail-la0-f42.google.com with SMTP id fe20so3799635lab.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Apr 2013 12:10:42 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1304042341530.24744@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jozsef,

Jozsef Kadlecsik wrote:
> On Thu, 4 Apr 2013, Michael Zintakis wrote:
>> Something we've discovered with regards to the nfacct match recently. If 
>> I have the following iptables statement:
>>
>> iptables -A INPUT -m nfacct --nfacct <nfacct_obj> -m <match2> -m <match3>
>>
>> The above aklways updates the "nfacct_obj" byte and packet counters, 
>> regardless of whether "match2" and "match3" actually matches. However, 
>> if we have:
>>
>> iptables -A INPUT -m <match2> -m nfacct --nfacct <nfacct_obj> -m <match3>
>>
>> then "nfacct_obj" counters are updated only when "match1" is satisfied, 
>> but if we have:
>>
>> iptables -A INPUT -m <match2> -m <match3> -m nfacct --nfacct <nfacct_obj>
>>
>> then "nfacct_obj" counters are updated when both match2 and match3 are 
>> matched (which was the initial intention).
>>
>> This inconsistency stems from the fact that the nfacct match in the 
>> kernel (xt_nfacct.c::nfacct_mt) always returns true, but also because of 
>> how iptables evaluates matches: it does so from left to right.
>>
>> Since there isn't a callback in the xt_match struct which is called 
>> after ALL matches have been satisfied (xt_match.match is called for each 
>> registered match in that statement), this causes the nfacct counters to 
>> be updated (or not) depending on the position of the nfacct match.
>>
>> What I have done locally is to add a separate callback (I called it 
>> "matched") which is called for all matches after all such matches in a 
>> particular statement have been satisfied, but that obviously will break 
>> lots of code depending on the old xt_match struct if such approach is 
>> adopted. My question is: is there more elegant solution to do this? 
> 
> In my opinion this is not inconsistency at all, but the intended 
> behaviour. So I don't see any reason to add such a hack to override it.
I meant inconsistent in terms of the end result, which in the example above is packet/bytes counting.

That result is different depending on the order of the conditions (i.e. matches) attached to the iptables rule. With the 'old' accounting we didn't have that. In other words, with the old accounting we've had:

If (match1 && match2 && matchN) {
  do_packet_and_bytes_counting();
}

No matter how we arrange the order of match1, match2 and matchN, the end result is (or should be) the same. With the nfacct match that isn't the case, but that isn't nfacct match's fault, but I guess it is because of the way iptables is examining the matches.

We would have had the consistency (in other words, getting a consistent result regardless of the order of the various conditions/matches) if nfacct was a target, not a match, but I know that would be difficult (I already examined that possibility) since the x_tables target does not provide a 'destroy' method, so there isn't a way to track the 'refcnt' in the nfacct kernel struct, so inventing this method is as equally as ugly as the hack I did with the nfacct match above, so I thought to ask and see whether there is a better solution.

> What prevents you from entering the matches in the order you want them to 
> be evaluated?
Nothing. Again, I am coming from the point of view of the 'old' accounting where I did not have that, so I didn't expect this change.
