From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 03:29:21 +0200
Message-ID: <44974F71.3050209@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606180055.25350.max@nucleus.it> <4496E2B2.6010209@trash.net>
	<200606200105.04286.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606200105.04286.max@nucleus.it>
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
> On Monday 19 June 2006 7:45 pm, Patrick McHardy wrote:
> 
> 
>>>This leads me to a more radical proposal. Is there any reason we don't
>>>have a general way to negate matches? It wouldn't be too difficult and we
> 
> [...]
> 
>>It would be useful for some matches (basically those that only check
>>a single attribute), others may want to combine negated matching
>>on some attributes with non-negated matching on others. In these
> 
> 
> I agree with you.
> Let's suppose we want to implement this feature and we don't want to cause 
> major breakage. I can't find a suitable bit in xt_entry_match, but we could 
> define a "wrapper match". We could set u.name to "!" or something similar and 
> data to:
> 
> struct {
>    int invert;
>    struct xt_entry_match nested_xt_entry_match;
> };
> 
> Similar wrappers would effectively transform a simple linear data structure in 
> a tree, so I don't think this is a thing we should endorse lighly.

I'm not sure how much effort we should put into glueing a generic
method around the matches, most already support proper negation and
we can just add it for the few(?) remaining ones manually (and I
don't accept new matches without proper negation support) and hope
for everything to get better with pkttables :)
