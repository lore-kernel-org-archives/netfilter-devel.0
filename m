From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC,
	NETFILTER]: amanda helper: convert to textsearch infrastructure
Date: Wed, 24 May 2006 03:32:23 +0200
Message-ID: <4473B7A7.2060707@netfilter.org>
References: <446DF48C.5020109@trash.net> <4473A8A8.3040801@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4473A8A8.3040801@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>  -        *tmp = '\0';
>> +    memset(&ts, 0, sizeof(ts));
>> +    stop = skb_find_text(*pskb, start, (*pskb)->len,
>> +                 search[SEARCH_NEWLINE].ts, &ts);
> 
> Better use strstr here: the textsearch infrastructure implements 
> algorithms only introduce trade off for patterns longer than one byte. 
> So, in this case, the infrastructure can not help in any way.

Please, forget this comment, strstr is not fragment-aware.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
