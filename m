From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8][CTNETLINK] Fix race condition on conntrack creation
Date: Tue, 08 Aug 2006 12:19:04 +0200
Message-ID: <44D86518.408@trash.net>
References: <44C61A2E.3060102@netfilter.org>	<200607281316.k6SDGBVP001926@toshiba.co.jp>
	<44CDE635.9060101@netfilter.org> <44D35CF5.1090502@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44D35CF5.1090502@ufomechanic.net>
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

Amin Azez wrote:
> * Pablo Neira Ayuso wrote, On 31/07/06 12:15:
> 
> I find it difficult to be comfortable with dropping some features of
> this patch. In this fragment, the second chunk does what looks like an
> important re-ordering of locking and conntrack creation; i.e. of course
> the lock is retained till after conntrack creation.
> 
> So I don't think it is safe to entirely drop this patch; Pablo?

I'll drop and and see which of the other ones still make sense.
