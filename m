From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 19:12:21 +0200
Message-ID: <4443CC75.4040703@trash.net>
References: <444132C1.1020604@trash.net>
	<44425DAE.3040007@trash.net>	<20060416.222435.02924300.davem@davemloft.net>	<200604171459.13312.dim@openvz.org>
	<4443B882.70203@trash.net> <jehd4sdvh1.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Mishin <dim@openvz.org>, dev@openvz.org,
	netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <jehd4sdvh1.fsf@sykes.suse.de>
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

Andreas Schwab wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
>>I'm not sure if we should really introduce this new type, it is
>>misleading for at least x86. IIRC the situation there is:
>>
>>- gcc < 4.0 always aligns u64 types to 4byte
> 
> 
> Are you sure about that? I can't reproduce that with gcc 3.3.3.

I mixed up the versions, the change was between 2.x and 3.x:

gcc-2.95 -O2:
basic type:     align 4
embedded type:  align 4
gcc-3.3 -O2:
basic type:     align 8
embedded type:  align 4

It only shows with optimization, with -O0 gcc-2.95 also uses 8 for
the basic type.

>>So there is no one compat_uint64_t type, but it depends on the
>>situation.
> 
> 
> The alignment of standalone objects is uninteresting, what is important is
> getting compatible layout of aggregates.

I couldn't come up with a realistic example where people would make
mistakes because of this, so I guess I have to agree, although my
feeling still disagrees :)
