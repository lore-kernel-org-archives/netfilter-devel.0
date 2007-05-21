From: Darren.Reed@Sun.COM
Subject: Re: Developing a user space library for filtering
Date: Mon, 21 May 2007 15:52:48 -0700
Message-ID: <465222C0.8050601@Sun.COM>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <46522166.1090603@gmx.net>
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

Carl-Daniel Hailfinger wrote:

>Hi Darren,
>
>On 22.05.2007 00:27, Darren.Reed@Sun.COM wrote:
>  
>
>>One of the core problems I see as people want to more and
>>more with firewall/NAT technology is integrate using it into
>>their application (whatever that may be.)  As time goes by,
>>this problem is becoming more and more acute and perhaps
>>is doing us (those who develop said technologies) a disservice
>>by making the "barrier to entry" too high.
>>    
>>
>
>Sorry if I'm being dense. Do you want to target firewall frontends
>or applications which have the desire to punch holes into the
>firewall?
>  
>

Neither.  Applications that sit on top of firewall software.

As an example, using squid on your Linux firewall/router in
transparent proxying mode requires that squid has some code
in it that knows how to talk to Linux in order to discover the
original destination and change the outgoing connection
such that the original address is used again.  Doing that
requires specific knowledge of the API that netfilter/iptables
uses.

Another example might be IDS software running on your Linux
firewall/router.  If that detects an attack, it should be able to
talk to netfilter/iptables and do "something" to mitigate it.

In both cases I'd like to see something developed such that
the 3rd party applications don't need to know what NAT or
firewall technology is being used.

Darren
