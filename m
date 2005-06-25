From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 21:00:41 +0200
Message-ID: <42BDA9D9.5030308@trash.net>
References: <42BD513E.6090306@eurodev.net> <42BD52A7.2090107@trash.net>
	<42BD5829.4030002@eurodev.net> <42BD5C41.2080505@trash.net>
	<42BDA6D6.5070604@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42BDA6D6.5070604@eurodev.net>
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

Pablo Neira wrote:
>> nf_reset is called independant of the contents of skb->nfct. nfctinfo
>> needs to be set to 0 so a packet isn't untracked afterwards anymore.
>> Think of tunnel devices.
> 
> OK. Hm, do you still consider that bad adding a line to nf_reset to
> reset skb->nfctinfo? This is the only drawback I see at the moment.

Its not about the line, I'm not sure about changing the fact that
nfctinfo is only valid if nfct != NULL. Its too hot to think right
now, please give me until tommorrow :)

Regards
Patrick
