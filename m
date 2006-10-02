From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfq_set_verdict_mark
Date: Mon, 02 Oct 2006 16:55:08 +0200
Message-ID: <4521284C.2070000@netfilter.org>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Scott <rbscott@cadvium.net>
In-Reply-To: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
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

Robert Scott wrote:
> i noticed that this function doesn't automatically convert the mark into
> the expected network byte order.  this is a minor detail, but the
> current behavior may confuse users. since nfq_get_nfmark automatically
> converts the mark into host order, i thought nfq_set_verdict_mark would
> also  do the reverse.
> 
> not really a big deal, and this will probably break most existing
> installations in the field, but perhaps a note in the docs to give new
> users a heads up.

Yes, I agree what you, we have to document this minor issue, I think
that we can introduce more API that can solve this inconsistency.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
