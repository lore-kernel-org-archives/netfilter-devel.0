From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] ipv6 support for libnetfilter_conntrack
Date: Wed, 21 Dec 2005 23:46:44 +0900 (JST)
Message-ID: <200512211446.jBLEkjg9001353@toshiba.co.jp>
References: <43A71EDD.3000805@eurodev.net>
	<43A74F85.1010203@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <43A74F85.1010203@eurodev.net>
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


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Tue, 20 Dec 2005 01:25:41 +0100

> Pablo Neira Ayuso wrote:
> > Hi Yasuyuki,
> > 
> > JFYI: I just added support for ipv6 to libnetfilter. I'll commit the
> > changes by myself once the new version of libnetfilter_conntrack is
> > released.
> > 
> > http://people.netfilter.org/pablo/libnetfilter-conntrack-ipv6.patch
> 
> And the conntrack-tool patch, still untested:
> 
> http://people.netfilter.org/pablo/conntrack-ipv6.patch

Great, I'll read deeply them this weekend.

BTW, I couldn't compile conntrack with these patches. 'union nfct_address'
seems not to be declared. If you will declare this union and use it
in libnetfilter_conntrack/include/libnetfilter_conntrack.h, I think you'd
better to do it before release.

And in __parse_inetaddr() in conntrack-ipv6.patch,

+	else if (inet_pton(AF_INET6, cp, &parse->addr6))
+		return AF_INET6;

this should be

+	else if (inet_pton(AF_INET6, cp, &parse->addr6) > 0)
+		return AF_INET6;

The only positive return value means success.

Regards,

-- Yasuyuki Kozakai
