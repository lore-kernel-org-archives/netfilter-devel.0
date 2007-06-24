From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Sun, 24 Jun 2007 16:48:44 +0200
Message-ID: <467E844C.6030600@trash.net>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
	<46714F7D.4010309@trash.net>
	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
	<467BDA90.7090802@trash.net>
	<Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
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
> On Fri, 22 Jun 2007, Patrick McHardy wrote:
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
>> Could you send me a Signed-off-by: line so I can queue this for 2.6.23?
> 
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>


Thanks Jozsef, applied. I've also added the missing ip6t_TRACE alias
to xt_TRACE.c.
