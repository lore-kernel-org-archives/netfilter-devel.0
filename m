From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNL_NFA_NEST
Date: Sat, 24 Mar 2007 12:30:28 +0100
Message-ID: <46050BD4.7080109@netfilter.org>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net> <46028242.4090609@netfilter.org>
	<460284D4.30709@trash.net> <4602B25B.10909@netfilter.org>
	<4602B667.2030304@trash.net> <4603C5AC.1070808@netfilter.org>
	<4603CF78.3030501@trash.net> <46041064.4080806@netfilter.org>
	<46050233.5040603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46050233.5040603@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> I just started thinking that probably the generic infrastructure should
>> support the nest bit. How crazy is this idea?
> 
> I don't know. It could accept them on the receive side without
> further problems since probably no netlink user will define
> more than 2^15 attributes, but could not send it since that
> would break compatibility. Since the kernel doesn't need it
> at all not sending it from userspace seems like a better
> solution to me.

Hm, then we'll have different message formats depending on the source.
If there is no choice I think that I prefer to keep it homogeneous, use
the conversion function and live with the library issues.

Alternatively, we could add support for the nest bit in the receive side
of genetlink and OR the nest bit in nfnetlink for messages sent to
userspace.

Thomas, do you have any suggestion on where to go?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
