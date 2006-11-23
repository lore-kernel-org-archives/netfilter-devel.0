From: Patrick McHardy <kaber@trash.net>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Thu, 23 Nov 2006 14:18:50 +0100
Message-ID: <45659FBA.2020505@trash.net>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
	<4557B157.6010205@netfilter.org>
	<Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
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
> Hi Pablo,
> 
> On Mon, 13 Nov 2006, Pablo Neira Ayuso wrote:
> 
> 
>>>Actually, how it is solved to pass the setting of dynamically assigned 
>>>(i.e. currently not registered) helpers? What about registering such 
>>>helpers with non-matching address/proto/port parameters?
>>
>>I'm unsure that I understand the question. Currently ctnetlink cannot
>>assign a helper that is not registered. Therefore, in order to register
>>a helper with non-matching parameter, wouldn't we need a new parameter
>>at modprobe stage? Perhaps some kind of userspace tool to manage helper
>>matching parameters could be interesting.
> 
> 
> The attached patch (on top of Patrick's nf_nat git tree and my patches 
> sent to this list) implements what I suggested: *do* register the helpers 
> which are actually assigned by an expectfn. Thus ctnetlink can find them 
> by name and then fill conntrack with the helper. In order to make sure a 
> bogus packet can't trigger such helpers, __nf_ct_helper_find had to be 
> modified. What do you think?


This is something needed for userspace-helpers (Harald did some work
in this direction), but I can't really think of what it could be used
for currently.
