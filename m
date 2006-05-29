From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Mon, 29 May 2006 03:27:59 +0200
Message-ID: <447A4E1F.7070105@trash.net>
References: <447707EB.7000401@trash.net>	<200605261504.k4QF4InW014648@toshiba.co.jp>	<447740CD.7030407@trash.net>
	<200605290025.k4T0PeSE014151@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200605290025.k4T0PeSE014151@toshiba.co.jp>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 26 May 2006 19:54:21 +0200
> 
>>>That patch is just the result of extracting jhash() and jhash_2words().
>>>I'm not familiar with hash algorithms. Does the degree of distribution
>>>become bad if we replaces 3 jhash_mix with something like XOR ?
>>
>>
>>I'd say no. jhash was chosen because it has good distribution even
>>for non uniformly distributed input values, so it shouldn't be
>>necessary to try to provide more uniformly distributed input values
>>by hashing multiple times.
> 
> 
> Well, I don't think so. If we employ a function which has bad
> distributin and we use outputs of it as inputs to jhash, the total result
> for tuple will have bad distribution.

Input distribution shouldn't matter as long as clashes can't
be caused deliberately before jhash is called. A simple way
to avoid this is to use a function that can't be solved for
a specific result without knowledge of a secret:

x = v1 ^ (v2 + secret)

which means you still need 2^31 tries on average to find a
(v1,v2) with two equal results (assuming 4 byte values).
