From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: What should we do with packets marked as INVALID?
Date: Thu, 28 Dec 2006 03:26:55 +0100
Message-ID: <45932B6F.3040802@netfilter.org>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> One of the most important feature provided by the netfilter subsystem is
> stateful connection tracking - the ability to decide that a packet is
> valid (or not) using not only data from a packet itself but also from a
> history of a flaw.
> 
> So, the question is: what should we do with packets marked as INVALID?
> 
> [...]
> 
> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
> invalid connections hang "forever") is also wrong, so maybe we should
> forward such packets and allow dst hosts to handle it
> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
> of the most important netfilter feature.

IMO, the default action should be drop. Having a look at the errors in
the tcp window tracking code, I can't think about a sane connection that
can generate invalid out of window packets even under packet lost.

> So, I have two propositions:
>  - Add another state (ex. UNCLEAN) for packet that matches
> proto/src/dst/sport/dport, but netfilter consider that it is wrong.

If you let the invalid packet go through just because there is a tuple
in the conntrack table that matches it then, why do you want the whole
TCP window tracking? Just disabled it via ip_conntrack_tcp_be_liberal if
you want to do so, out of window packets will not be marked as invalid,
and you can still drop unclean packets since they are marked as invalid.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
