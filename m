From: Andre Correa <andre.correa@pobox.com>
Subject: Re: stability of IMQ?
Date: Mon, 06 Sep 2004 11:55:12 -0300
Sender: linux-net-owner@vger.kernel.org
Message-ID: <413C7A50.6000707@pobox.com>
References: <876ef97a040901130117c0e91a@mail.gmail.com> <Pine.LNX.4.60.0409020925530.3129@dahlia.cs.iitm.ernet.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tobias DiPasquale <codeslinger@gmail.com>,
	linux-net <linux-net@vger.kernel.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Dinil Divakaran <dinil@lantana.tenet.res.in>
In-Reply-To: <Pine.LNX.4.60.0409020925530.3129@dahlia.cs.iitm.ernet.in>
List-Id: netfilter-devel.vger.kernel.org


Hi, I can tell that IMQ is proving to be much more stable then it was 
suppoed to be on january when we got the project up again after being 
unmantained for some time. Users mailling list has more then 200 people 
now and many of then, including me, using IMQ on heavy traffic gateways 
without problems.

You just should avoid modules on 2.6 series. There is a reported issue 
with iptraf on 2.6 too (it stops counters, not the traffic), nothing 
serious.

A new version is about to be released for <=2.6.7 with new features like 
choose number of devices, choosing "where" it hooks and some others.

Dinil, I would like to ask you to report your issue with iptables to the 
IMQ list or directly to me so we can investigate what went wrong and, if 
needed, find a solution.

Tks

Andre



Dinil Divakaran wrote:
>>
>> I am considering using IMQ for some ingress shaping action and I was
>> wondering if anyone else was using it and how stable it is. Have their
>> been an persistent Oops problems? Any other serious issues? The site
>> seems to indicate some problems in certain situations, so I was
>> wondering about this before I got into it too heavily. Thanks for all
>> the help in advance!
> 
> 
> I 've used IMQ on kernel 2.4.21 and it doesn't seem to have
> any kind of problem.
> 
> I couldn't get it working for 2.6.7 kernel. There was some problem
> patching iptabels !
> 
> Cheers,
> Dinil
> 
> 
> 
> 

