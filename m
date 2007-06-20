From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 13:32:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
	<46790A58.9050106@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46790A58.9050106@netfilter.org>
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


On Jun 20 2007 13:07, Pablo Neira Ayuso wrote:
>> 
>> But it works with UDP too. This if() block looks merely like a
>> watch-out-for-TCP exception. (And obviously, lacks SCTP/DCCP checking.)
>
> I see, still I think that it would be worth to make it completely independent
> of it.

UDP does not have a transition from ESTABLISHED -> TIME_WAIT, to begin with.

>> > I think that it would be worth a
>> > rework. Luke, use the connection tracking event API :)
>> 
>> Where may I find examples?
>
> Have a look at nf_conntrack_netlink.c look for the x_events() function. If
> you have more questions on it. Let me know.

I think netlink is an overkill here. Well, at least I could not find
something usable right away.
Something like


myfunction( ??? )
{
	/* kill connlimit entry */
}

__init init_module()
{
	nf_register_whatever(ON_TCP_TRANSITION, myfunction);
}

I just don't see any modules (matches, targets) that use events yet.
Could you cook it up?


	Jan
-- 
