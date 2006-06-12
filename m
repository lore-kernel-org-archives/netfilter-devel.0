From: Pablo Neira Ayuso <pneira@us.es>
Subject: Re: [PATCH] entry_data
Date: Mon, 12 Jun 2006 11:50:18 +0200
Message-ID: <448D38DA.8000404@us.es>
References: <200606050029.08602.max@nucleus.it>
	<200606120119.16503.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606120119.16503.max@nucleus.it>
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

Massimiliano Hofer wrote:
> an API isn't worth much if nobody uses it. :)
> Here is an example of a module that takes advantage of the patch in my 
> previous post.
> 
> It is a new version of xt_condition ported to 2.6.17-rc6 with entry_data. Just 
> install the regular patchlet and substitute net/netfilter/xt_condition.c with 
> the attacched source.
> 
> The advantages gained thanks to entry_data are that now match() and destroy() 
> are O(1). The overall code is shorter and, IMHO, clearer.
> 
> WARNING: this version of condition is still experimental. It worked in my 
> preliminary tests, but I will release a more reliable version as soon as 
> 2.6.17 becomes stable.

Fine, please next time send an incremental diff so we all can notice the 
changes by having a look at the attachment. Thanks.
