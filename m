From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Mon, 29 Aug 2005 13:14:49 +0200
Message-ID: <4312EE29.9040102@trash.net>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>
	<20050828122130.GH4244@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050828122130.GH4244@rama.de.gnumonks.org>
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
> However, I think we make our lives much more easy when we make
> ip_conntrack / nf_conntrack a compile-time decision.  This way we avoid
> compromising any run-time efficiency at the cost of some configurations
> where the user doesn't know at compile time which of the two systems he
> should use.
> 
> I also dislike the "CONNTRACK_IPV4_DEFAULT" config option that you use
> in your patches.  I think it was introduced because we cannot have two
> modules that supply the same symbol.  
> 
> I think we either make the ip_conntrack/nf_conntrack decision at
> compile-time (like stated above), _or_ we find a run-time solution that
> will work transparently with both ip_conntrack and nf_conntrack.
> Whatever we use for the actual implementation (macros, glue functions,
> ...) is a different question.

I feel reluctant to add complexity just so users can switch between
them at runtime. It may be useful for debugging, but it doesn't look
like a realistic usage scenario. So I would also prefer having a
compile-time choice.
