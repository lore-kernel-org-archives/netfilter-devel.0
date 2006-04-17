From: Dmitry Mishin <dim@openvz.org>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 16:04:17 +0400
Message-ID: <200604171604.18471.dim@openvz.org>
References: <444132C1.1020604@trash.net> <200604171459.13312.dim@openvz.org>
	<je64l8fmhw.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <je64l8fmhw.fsf@sykes.suse.de>
Content-Disposition: inline
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

On Monday 17 April 2006 15:51, Andreas Schwab wrote:
> Dmitry Mishin <dim@openvz.org> writes:
> > diff --git a/include/asm-ia64/compat.h b/include/asm-ia64/compat.h
> > index 40d01d8..3e6417b 100644
> > --- a/include/asm-ia64/compat.h
> > +++ b/include/asm-ia64/compat.h
> > @@ -34,6 +34,8 @@ typedef s32		compat_long_t;
> >  typedef u32		compat_uint_t;
> >  typedef u32		compat_ulong_t;
> >
> > +typedef u64 __attribute__((aligned(4)))	compat_uint64_t;
>
> The aligned attribute cannot decrease alignment.
With my gcc (3.3.5) it can. Which solution do you propose?
__attribute__((packed, aligned(4)))?
Or 
#ifdef  ARCH_HAS_FUNNY_ALIGNMENT
struct compat_xt_counters {
	uint32_t cnt[4];
}
#else
#define compat_xt_counters xt_counters
#endif
?

>
> Andreas.

-- 
Thanks,
Dmitry.
