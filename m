From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Thu, 30 Aug 2007 20:40:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>
References: <46D06522.2090509@hotpop.com> <46D06FF8.5090004@hotpop.com>
	<46D5A5B9.2030107@trash.net> <46D6DEAF.9010009@hotpop.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Peter Riley <Peter.Riley@hotpop.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D6DEAF.9010009@hotpop.com>
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


On Aug 30 2007 08:13, Peter Riley wrote:
>Patrick McHardy wrote:
>> 
>> I count 132 occurences of nfcache (a few are in headers that must stay
>> though). I'll happily apply a patch that kills them all.
>> 
>
>Patrick, yes I get 134 occurrences on 132 lines in current svn.
>The breakdown appears to me to be:
[...]

>	printf("Cache: %08X ", e->nfcache);
>	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
>	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
>
>     It seems that there is good reason for printing out nfcache contents as long as
>     those bits are still present in structs ipt_entry/ip6t_entry defined in headers
>     on the kernel side.  After all, this is how I tracked down the problem I am
>     reporting to begin with!

Do we still need nfcache anyway?


	Jan
-- 
