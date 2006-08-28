From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_LOG and friends. Question
Date: Mon, 28 Aug 2006 15:18:33 +0200
Message-ID: <44F2ED29.8020204@trash.net>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
	<44EDD07D.1020805@trash.net>
	<20060827150456.GA9190@kriss.csbnet.se>
	<44F2CC09.4060109@trash.net>
	<20060828120334.GA8994@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060828120334.GA8994@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-28 12:57:13+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>>2. I have merged ipt_LOG and ip6t_LOG into xt_LOG. With common
>>>dump_tcp()/udp() and some other small code. This also works good. 
>>
>>If it stays compatible and results in less code, that one too.
> 
> 
> Yes, it _should_ be the same. The code is somewhat changed but the result
> should produce exactly the same. It might have introduced some bug? So
> handing it in an early rc-tree of 2.6 or give me time to run the code on our
> router for a few weeks. What ever you like :-)

I'll look over it when you send it to make sure.

>>>3. The prefix is missing a space between the prefix and IN=interface. Very
>>>annoying to always have to use -j LOG --log-prefix "one two three ". Notice
>>>the last space. Will this break anything if i just add a space in between of
>>>"%sIN=%s OUT..." for the prefix?
>>
>>Yes, people already add the extra space and it would at least change
>>how log files look, potentially even break parsers.
>>
> 
> 
> Hm, hard one. I guess it's not enough to only change this to revision 1 as
> the parameter is the same and so on. And the code i wrote doesn't make any
> difference between revision 0 and 1 during the packet dumping functions.
> They are the same.
> 
> I guess the only way to solve this is to add a new flag in revision 1
> (beside keeping old --log-prefix with the missing space. --log-text-prefix,
> --log-text-sulfix ? I'll think of something.

That doesn't look to useful .. if I have to say --trailing-prefix-space
I can just as well just specify it in the prefix itself.

>>>7. It would be very nice if we had a -m log. This is very easy todo in
>>>kernel-space. Only that we have to call it -m LOG (uppercase) for userspace
>>>to load the correct library and kernel module. Its just a matter of the
>>>module registering both as a match and a target. Bad idea? It would be very
>>>convinent. The match would just log the packet and always return true
>>>(match). Compare this to the comment module that doesn't actually do any
>>>match-work.
>>
>>I think this is something that can wait for a infrastructure that is
>>meant to do things like that.
>>
> 
> 
> I already written it :-/. Havn't written userspace yet and not tested it.

Please leave it away for now. We can discuss this as a next step,
I guess it doesn't affect the other changes.

>>>7. Currently i always use my LOGing with a limiter to not flood the
>>>ringbuffer. I guess most people are. There would be very nice with a
>>>--log-limit 5, meaning we will only log 5 packets per second. Also an
>>>inverter for that so --log-limit ! 6 means to log everypacket hiting the
>>>rule above 6 packet per second. This will go very well with LOG being a
>>>match as well. As it simply selects which packets to log and always matches
>>>them to continue in the firewall rules. Again this is a revison 1 thing. The
>>>code for this in kernel is very simple. 
>>
>>Whats wrong with using the limit match?
> 
> 
> It fits with -m LOG (the match). You then can write: 
> 
> iptables -m match ... -m LOG --log-prefix 'monkey' --log-limit 5/s -j DROP 
> 
> Mening that we will drop every match matching the 'match' but only log a few
> of them. This saves rules (and therefore CPU). I have tons of small
> terminating chains just for LOGing and then DROPing the packet. Two targets.
> 
> Old iptables needs:
> iptables -N logging_droping_chain
> iptables -A chain -m match ... -j logging_droping_chain
> iptables -A logging_droping_chain -m limit --limit 5/s -j (U)LOG --log-prefix 'monkey'
> iptables -A logging_droping_chain -j DROP
> 
> Now, if you have a really large firewall, you have alot of terminating
> matches likes these. Having a -m LOG (with a limiter to not flood of the
> logging path) will save alot of memory and CPU-cycles oof already stressed
> routers/firewalls.
> 
> The time to get -a action (or sometime similar) added isn't soon here. :-/
> I'm not saying we need to get this in mainline kernel. I'll keep it as a
> patch in my svn-repository if needed.

Thats fine of course. Adding support for actions wouldn't be too hard
btw, but I don't want to open new construction sites in that area
while we haven't even got support for x_tables in userspace.
