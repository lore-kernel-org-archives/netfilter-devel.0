From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] ipv6 support for libnetfilter_conntrack
Date: Thu, 22 Dec 2005 13:29:46 +0900 (JST)
Message-ID: <200512220429.jBM4TlXa017132@toshiba.co.jp>
References: <43A74F85.1010203@eurodev.net>
	<200512211446.jBLEkjPN021538@toshiba.co.jp>
	<43A9904A.6040609@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <43A9904A.6040609@eurodev.net>
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

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Wed, 21 Dec 2005 18:26:34 +0100

> Yasuyuki KOZAKAI wrote:
> >>Pablo Neira Ayuso wrote:
> >>>JFYI: I just added support for ipv6 to libnetfilter. I'll commit the
> >>>changes by myself once the new version of libnetfilter_conntrack is
> >>>released.
> >>>
> >>>http://people.netfilter.org/pablo/libnetfilter-conntrack-ipv6.patch
> >>
> >>And the conntrack-tool patch, still untested:
> >>
> >>http://people.netfilter.org/pablo/conntrack-ipv6.patch
> > 
> > Great, I'll read deeply them this weekend.
> > 
> > BTW, I couldn't compile conntrack with these patches. 'union nfct_address'
> > seems not to be declared. If you will declare this union and use it
> > in libnetfilter_conntrack/include/libnetfilter_conntrack.h, I think you'd
> > better to do it before release.
> 
> Hm, maybe you have an old working copy. I commited that change ~8 hours
> ago, see SVN ;)

Now I can build. Thanks.

> > And in __parse_inetaddr() in conntrack-ipv6.patch,
> > 
> > +	else if (inet_pton(AF_INET6, cp, &parse->addr6))
> > +		return AF_INET6;
> > 
> > this should be
> > 
> > +	else if (inet_pton(AF_INET6, cp, &parse->addr6) > 0)
> > +		return AF_INET6;
> > 
> > The only positive return value means success.
> 
> I must be missing anything. From inet_pton manpage:
> 
> The inet_pton() function shall return 1 if the  conversion succeeds,
> with the  address  pointed  to  by dst in network byte order. It shall
> return 0 if the input is not a valid IPv4 dotted-decimal string or a
> valid  IPv6  address string,  or -1 with errno set to [EAFNOSUPPORT] if
> the af argument is unknown.
> 
> Still required such change? Thanks!

I think nowadays inet_pton() in almost distributions support AF_INET6, too.
But I don't want to assume that.

-- Yasuyuki Kozakai
