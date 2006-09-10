From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] simplify the code to dump the conntrack table
Date: Mon, 11 Sep 2006 00:56:55 +0200
Message-ID: <45049837.3050208@netfilter.org>
References: <45001B82.4000504@netfilter.org> <4500370F.5050002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4500370F.5050002@trash.net>
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
>> Merge the bits to dump the conntrack table and the ones to dump and
>> zero counters in a single piece of code. This patch does not change
>> the default behaviour if accounting is not enabled.
> 
> Nice cleanup, thanks. And it saves me from removing the id based
> dumping, which I forgot to change for the counter case :)

Thanks. So I guess that the next question is if there is any plan to
remove the id ;)

> BTW, what about my last question regarding your early_drop patch?

Sorry, I forgot to do it, please mangle the patch and use '>' instead of
'>=', otherwise the maximum number of conntracks will be ip_conntrack_max-1.

BTW, did you have the chance to have a look these patches?

http://lists.netfilter.org/pipermail/netfilter-devel/2006-August/025345.html
http://lists.netfilter.org/pipermail/netfilter-devel/2006-August/025353.html

@Jozsef: I forgot to include you in the CC, the second patch above
touches some of your TCP tracking bits '[PATCH 2/3][CONNTRACK] Introduce
the pickup facilities to take over TCP connections'

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
