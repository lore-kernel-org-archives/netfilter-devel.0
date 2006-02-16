From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] nf_conntrack_ipv[4|6] load on demand for x_tables
 matches/targets, take #2
Date: Thu, 16 Feb 2006 09:43:20 +0100
Message-ID: <43F43B28.4000908@trash.net>
References: <43EFF1E0.8090102@netfilter.org>
	<20060213111513.GS4601@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060213111513.GS4601@sunbeam.de.gnumonks.org>
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
> On Mon, Feb 13, 2006 at 03:41:36AM +0100, Pablo Neira Ayuso wrote:
> 
>>Thanks to Yasuyuki Kozakai for all the feedback.
>>
>>[NF_CONNTRACK] nf_conntrack_ipv[4|6] load on demand for x_tables
>>matches/targets, take #2
> 
> 
> this also looks fine to me, but might clash with some (unpublished?)
> work of Patrick McHardy on putting mist of the checkfn/... stuff into
> data structures.  
> 
> Patrick? What about pushing your changes to net-2.6.17?

I'll probably push them out tonight. They do something similar as
Pablo's patches, but instead of passing only the address family,
the family is stored in the struct xt_{match,target} and a pointer
to the struct is given to the match/target functions, so we also
have the revision available at runtime.

Pablo, please resubmit on top of my patches once I've posted them.
