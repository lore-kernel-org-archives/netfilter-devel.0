From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 21:30:41 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409292125030.16633@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk>
	<Pine.LNX.4.61.0409291042240.11661@filer.marasystems.com>
	<415AE4CE.3030305@parknet.dk>
	<Pine.LNX.4.61.0409291837430.15266@filer.marasystems.com>
	<415AFD18.4090503@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415AFD18.4090503@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Simon Lodal wrote:

> Henrik Nordstrom skrev:
>> On Wed, 29 Sep 2004, Simon Lodal wrote:
>> 
>>> When people talk about the 10.44 network, I assume they append .0.0, not 
>>> insert them in the middle. My proposal does that with a double dot, eg. 
>>> 10..44 = 10.0.0.44.
>> 
>> There is a well established meaning in the computing industry of 10.44 to 
>> mean 10.0.0.44, not 10.44.0.0.
>
> Really?

Yes, really. It has been like this since BSD networking first saw the 
light.

> Ok but hey is ping just a testbed for strange notations? What other programs 
> (and users) actually accept all these notations? And I am talking real world 
> use on Linux (as long as iptables is not ported to bsd).

Quite many programs accept this notation.

> strlen(".1") = 2
> strlen("1/0.0.0.255") = 11
>
> That's why.

Not a reason imho.

If you had said that .1 is a whole lot easier to understand as an 
administrator than 0.0.0.1/0.0.0.255 then there may be valid arguments.

With this kind of IP expressions extremely rare I actually prefer to have 
a long syntax for it to make sure it is not done by mistake. Shorter is 
not neccesarily better unless it is something which is typed very very 
often.

Regards
Henrik
