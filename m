From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] ipv6 support for libnetfilter_conntrack
Date: Thu, 22 Dec 2005 11:48:47 +0100
Message-ID: <43AA848F.1070604@eurodev.net>
References: <43A74F85.1010203@eurodev.net>	<200512211446.jBLEkjPN021538@toshiba.co.jp>	<43A9904A.6040609@eurodev.net>
	<200512220429.jBM4Tlqg005695@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512220429.jBM4Tlqg005695@toshiba.co.jp>
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
>>>And in __parse_inetaddr() in conntrack-ipv6.patch,
>>>
>>>+	else if (inet_pton(AF_INET6, cp, &parse->addr6))
>>>+		return AF_INET6;
>>>
>>>this should be
>>>
>>>+	else if (inet_pton(AF_INET6, cp, &parse->addr6) > 0)
>>>+		return AF_INET6;
>>>
>>>The only positive return value means success.
>>
>>I must be missing anything. From inet_pton manpage:
>>
>>The inet_pton() function shall return 1 if the  conversion succeeds,
>>with the  address  pointed  to  by dst in network byte order. It shall
>>return 0 if the input is not a valid IPv4 dotted-decimal string or a
>>valid  IPv6  address string,  or -1 with errno set to [EAFNOSUPPORT] if
>>the af argument is unknown.
>>
>>Still required such change? Thanks!
> 
> I think nowadays inet_pton() in almost distributions support AF_INET6, too.
> But I don't want to assume that.

OK. I'll also add some extra checkings for inet_pton() at ./configure stage.

-- 
Pablo
