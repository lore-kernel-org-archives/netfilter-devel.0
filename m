From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 16 Feb 2006 09:33:57 +0100
Message-ID: <43F438F5.8070607@trash.net>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060213112028.GU4601@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Mon, Feb 13, 2006 at 03:41:52AM +0100, Pablo Neira Ayuso wrote:
> 
>>[NF_CONNTRACK] first conntrack ID must be 1 not 2
>>
>>The first conntrack ID must be 1. If a new conntrack is created, the
>>general ID counter must be post-incremented instead pre-incremented
>>since [ip|nf]_conntrack_next_id is initialized to 1. Same applies for
>>expectations.
> 
> 
> looks clean to me.  Interesting question though: Does it matter whether
> we start with 1 or 2?  Am I missing something?

Its irrelevant since the number doesn't have any meaning beyond beeing
an identifier. Anyway, I'd prefer a patch that just removes the
initialization to 1.
