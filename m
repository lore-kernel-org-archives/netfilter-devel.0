From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Mon, 18 Jun 2007 15:08:16 +0200
Message-ID: <467683C0.1030703@trash.net>
References: <466FB176.7040306@netfilter.org>	<twig.1181752139.4605@bugmachine.ca>
	<467020F6.2050906@trash.net>	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>	<46713EE8.6060906@trash.net>	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>	<46714F7D.4010309@trash.net>	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>	<46767F60.5080208@trash.net>
	<Pine.LNX.4.64.0706181453070.13474@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706181453070.13474@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Mon, 18 Jun 2007, Patrick McHardy wrote:
> 
>> Jozsef Kadlecsik wrote:
>>
>>> Attached you can find the reworked TRACE target, which does not suffer
>>> from backward incompatibility. Unfortunately I had to steal one unused
>>> bit from skbuff to be able to mark the packets so that it surely does
>>> not clash with any rules using the standard "MARK" target. Logging
>>> level, flags and type are hardcoded. What do you think?
>>
>>
>> Looks pretty good. Maybe we can avoid using the skb bit though, what
>> do you think about letting the user set a special "trace-mark" value
>> through /proc and using that? Not sure if thats better or worse :)
> 
> 
> If one uses 'MARK --set-mark' and would want to trace a living ruleset,
> he'd be forced to change the ruleset in order to be able to use tracing.
> And that's a full can of worms...


Good point.

> Hey, we returned the all 32 bit of nfcache! This is just one bit getting
> back ;-)


Fair enough I guess :) The bit is unused anyway, so at least for now it
won't do any harm. I'll do some more thoroughly review in the next days
and queue it for 2.6.23 if no other issues come up.
