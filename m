From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Re: 2.6.14-rc1 Critical bug: machine complete freeze
Date: Sun, 18 Sep 2005 18:58:55 +0200
Message-ID: <432D9CCF.6000104@trash.net>
References: <20050917133943.30983afd.akpm@osdl.org> <432C8178.40201@trash.net>
	<432C8398.9060202@gmail.com> <432C8590.9070600@trash.net>
	<432D15BC.3070500@gmail.com> <432D81DB.5010106@trash.net>
	<432D944D.9020800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: patrizio.bassi@gmail.com
In-Reply-To: <432D944D.9020800@gmail.com>
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

Patrizio Bassi wrote:
> Patrick McHardy ha scritto:
> 
>>> My iptables script was about 1 year old, and worked perfectly.
>>> New kernel (dunno which...2.6.1x) introduced this problem.
>>>   
>> Try adding some logging rules to see why it gets dropped (-m state
>> --state INVALID for example).
>>
> the question is: why first time it's dropped and after reload not?

If the ping is already running before you load your NAT rules their
might already be state for the "connection" without NAT initialized.

> i've also supposed a time problem..waiting for bridge propagating and so
> on.
> 
> after some mins i tried, and got same problem, so there must be some
> initialization problems.
> 
> i suspect in bridge interface enabling/disabling and iptables in
> following bridge changes.

I don't know your setup, so I can't comment on this. But again,
some logging rules should at least tell whats happening to the
packets.
