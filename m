From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 23 Feb 2006 10:48:57 +0100
Message-ID: <43FD8509.9070203@trash.net>
References: <43F44794.1080203@trash.net>	<43FB0FBA.4060609@netfilter.org>	<43FBD887.9040409@netfilter.org>
	<200602221301.k1MD1lIb015798@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602221301.k1MD1lIb015798@toshiba.co.jp>
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
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Wed, 22 Feb 2006 04:20:39 +0100
> 
> 
>>>                                       Moreover, the expectation mask has
>>>l3num value that is different from the l3num in the nfnetlink header,
>>>that's why I introduced this field.
> 
> 
> Yes, but in the current code l3num in expectation mask is always 0xff.
> And even if we port all helpers of ip_conntrack to nf_conntrack,
> they will set 0xff to l3num.
> 
> Which situation kernel wants to set the value except of 0xff to l3num
> in expectation mask ?

Harald and me were actually talking about simplifying the helper lookup
by making the dst part of an expectation fixed (for ip_conntrack). With
nf_conntrack l3num is in the src-part of the tuple, but thats just
for memory-efficiency, it can be treated equally to protonum and the
mask can be eliminated.
