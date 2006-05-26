From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Fri, 26 May 2006 19:54:21 +0200
Message-ID: <447740CD.7030407@trash.net>
References: <447703F2.90401@trash.net>	<20060526.224556.19965528.yoshfuji@linux-ipv6.org>	<447707EB.7000401@trash.net>
	<200605261504.k4QF4InW014648@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200605261504.k4QF4InW014648@toshiba.co.jp>
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
>>But anyway, this is just a possible micro-optimization, the
>>real question is why we need three invocations of jhash_mix.
> 
> 
> That patch is just the result of extracting jhash() and jhash_2words().
> I'm not familiar with hash algorithms. Does the degree of distribution
> become bad if we replaces 3 jhash_mix with something like XOR ?


I'd say no. jhash was chosen because it has good distribution even
for non uniformly distributed input values, so it shouldn't be
necessary to try to provide more uniformly distributed input values
by hashing multiple times.
