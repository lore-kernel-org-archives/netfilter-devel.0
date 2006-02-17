From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 11:11:26 +0100
Message-ID: <BAY103-F81B8A00B6663452743916B2F80@phx.gbl>
References: <43F5978E.8010203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43F5978E.8010203@trash.net>
To: kaber@trash.net
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

>Marco Berizzi wrote:
> >
> > Patrick McHardy wrote:
> >
> >> I can't see a mistake. Can you please add a logging rule to log
> >> the packets that get dropped without the ACCEPT rule?
> >
> >
> > Sure! Here is:
> >
> > root@Halley:/tmp# iptables -D INPUT -s venezia-gateway -j ACCEPT
> >
> > [started ping from a venezia private host ----> to firenze private host]
> >
> > root@Halley:/tmp# iptables -I INPUT -s venezia-gateway -j LOG
> > --log-level debug --log-ip-options
> >
> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
> > SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00
> > TTL=53 ID=45921 PROTO=ESP SPI=0x583f3ff9
> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
> > SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53
> > ID=45921 PROTO=4
>
>Thats odd, these packets should be caught by your ESP rule, so I guess
>they must be dropped by another rule. Please post your full ruleset with
>iptables -vxnL.

Me again. Aha! Found!!! ;-))

iptables -I INPUT -s venice-gateway --protocol 4 -j ACCEPT

did the trick.

Patrick, thanks a lot for the feedback.
