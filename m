From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 17:47:14 +0200
Message-ID: <4443B882.70203@trash.net>
References: <444132C1.1020604@trash.net> <44425DAE.3040007@trash.net>
	<20060416.222435.02924300.davem@davemloft.net>
	<200604171459.13312.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200604171459.13312.dim@openvz.org>
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

Dmitry Mishin wrote:
> This patch introduces compat_uint64_t type, which is required for proper 
> handling different alignment of structures, containing u64 objects, on 
> compatible with ia32 64bit platforms and others.
> 

> diff --git a/include/asm-ia64/compat.h b/include/asm-ia64/compat.h
> index 40d01d8..3e6417b 100644
> --- a/include/asm-ia64/compat.h
> +++ b/include/asm-ia64/compat.h
> @@ -34,6 +34,8 @@ typedef s32		compat_long_t;
>  typedef u32		compat_uint_t;
>  typedef u32		compat_ulong_t;
>  
> +typedef u64 __attribute__((aligned(4)))	compat_uint64_t;
> +
>  struct compat_timespec {
>  	compat_time_t	tv_sec;
>  	s32		tv_nsec;

I'm not sure if we should really introduce this new type, it is
misleading for at least x86. IIRC the situation there is:

- gcc < 4.0 always aligns u64 types to 4byte
- gcc >= 4.0 aligns basic u64 types to 8byte, u64's embedded in
  structures to 4 byte

So there is no one compat_uint64_t type, but it depends on the
situation.
