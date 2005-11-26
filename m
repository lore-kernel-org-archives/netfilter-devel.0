From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack & NAT
Date: Sun, 27 Nov 2005 00:52:15 +0100
Message-ID: <4388F52F.8050902@trash.net>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>	<200511231225.jANCPmnh018866@toshiba.co.jp>	<Pine.LNX.4.64.0511231342490.16555@bizon.gios.gov.pl>
	<200511250454.jAP4sJeD003744@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200511250454.jAP4sJeD003744@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Krzysztof Oledzki <olenf@ans.pl>
> Date: Wed, 23 Nov 2005 14:44:01 +0100 (CET)
> 
>>Oh. So how we are going to make transparent proxy, port redirects, etc 
>>possible?
> 
> 
> At first, I will not implement IPv6 NAT at least, but I don't know
> what other people think.
> 
> And about transparent proxy, port redirects, load balancer, and so on,
> indeed currently we seems that we don't have smarter and de facto standard
> solutions.
> 
> I wonder why they haven't come up yet, but anyway, I believe people can
> develop smarter solutions than copied and pasted IPv4 NAT (It's possible that
> just I don't know them and someone might have already developed them).
> I think it's still early to give up on.

Transparent proxying can be done with tproxy without NAT (I'm not
sure how far along their new patches are), the idea is to exchange
the dst_entry of the skb instead of rewriting packets.
