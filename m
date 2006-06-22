From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Thu, 22 Jun 2006 17:18:36 +0200
Message-ID: <449AB4CC.6030804@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606210203.33209.max@nucleus.it> <44989321.2000106@trash.net>
	<200606220150.23537.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606220150.23537.max@nucleus.it>
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

> What about struct xt_target?
> It has the same general structure, but I've not touched it yet.
> It would be coherent to change it too, but I'd break compatibility with 
> external targets for no real gain.
> Would any target benefit from having priv_data?

I think the CLUSTERIP target would. I think we should keep the
interfaces in sync, we've changed it twice during the last two
kernel versions, so I don't really see external stuff as a problem.
