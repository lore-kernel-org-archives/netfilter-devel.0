From: Allen Francom <aef@prismnet.com>
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 02:11:47 -0500 (CDT)
Message-ID: <20070522020457.M92606@tempest.prismnet.com>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465222C0.8050601@Sun.COM>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org



I worked a little bit with "Hogwash".
http://hogwash.sourceforge.net/docs/overview.html

This was a mangling of IDS/Snort into layer 2 for real-time filtering.

With a little help from my friends there I got an IPTables "target"
so that IPTables could direct traffic into the hogwash/snort.

I like it that you said "libc".

It would be nice to intercept traffic after stream reassembly which was 
always a problem.

In that case what you're asking makes maybe more sense to focus on "libc" 
itself and having an "intercept" there.

That way you could for example filter stream-reassembled data coming into 
a web server, or not, depending on the "rules engine" deciding to catch 
the traffic or not.

I always thought that would be the place to be, in the call to get data, 
but hookable, like a library with a hook that checks to see if it should 
be "scrubbing" incoming traffic on a particular port.

"Slick" is the word.

Word.

;)

-AEF


On Mon, 21 May 2007, Darren.Reed@Sun.COM wrote:

> Carl-Daniel Hailfinger wrote:
>
>> Hi Darren,
>> 
>> On 22.05.2007 00:27, Darren.Reed@Sun.COM wrote:
>> 
>>> One of the core problems I see as people want to more and
>>> more with firewall/NAT technology is integrate using it into
>>> their application (whatever that may be.)  As time goes by,
>>> this problem is becoming more and more acute and perhaps
>>> is doing us (those who develop said technologies) a disservice
>>> by making the "barrier to entry" too high.
>>> 
>> 
>> Sorry if I'm being dense. Do you want to target firewall frontends
>> or applications which have the desire to punch holes into the
>> firewall?
>> 
>
> Neither.  Applications that sit on top of firewall software.
>
> As an example, using squid on your Linux firewall/router in
> transparent proxying mode requires that squid has some code
> in it that knows how to talk to Linux in order to discover the
> original destination and change the outgoing connection
> such that the original address is used again.  Doing that
> requires specific knowledge of the API that netfilter/iptables
> uses.
>
> Another example might be IDS software running on your Linux
> firewall/router.  If that detects an attack, it should be able to
> talk to netfilter/iptables and do "something" to mitigate it.
>
> In both cases I'd like to see something developed such that
> the 3rd party applications don't need to know what NAT or
> firewall technology is being used.
>
> Darren
>
>
>
