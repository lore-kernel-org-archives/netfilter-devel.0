From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfq_set_verdict_mark
Date: Tue, 10 Oct 2006 07:20:26 +0200
Message-ID: <452B2D9A.7080702@trash.net>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
	<4521284C.2070000@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Robert Scott <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4521284C.2070000@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Robert Scott wrote:
> 
>>i noticed that this function doesn't automatically convert the mark into
>>the expected network byte order.  this is a minor detail, but the
>>current behavior may confuse users. since nfq_get_nfmark automatically
>>converts the mark into host order, i thought nfq_set_verdict_mark would
>>also  do the reverse.
>>
>>not really a big deal, and this will probably break most existing
>>installations in the field, but perhaps a note in the docs to give new
>>users a heads up.
> 
> 
> Yes, I agree what you, we have to document this minor issue, I think
> that we can introduce more API that can solve this inconsistency.

Do we actually have documentation where we can document it? :)

I'm beginning to wonder how much more kludges we will have in these
libraries by continuing to treat them as stable without having had
even a single beta version.
