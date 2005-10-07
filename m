From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] don't use __be16 in files used by userspace
Date: Fri, 07 Oct 2005 13:24:56 -0700 (PDT)
Message-ID: <20051007.132456.19624093.davem@davemloft.net>
References: <20051007103105.GF4719@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007103105.GF4719@rama>
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

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 7 Oct 2005 12:31:05 +0200

> This (or a different solution such as 
> "#ifndef __KERNEL__ #define __be16 #endif" needs to go in before 2.6.14
> is released, since otherwise we'd break userspace compilation :(

I'm not applying this.

The reverting of endianness annotations would be a serious
regression.  If we need userland compatible defines we can
either:

1) Do what iproute2 and friends do, which is ship sanitized
   kernel headers in their userland source tree.

2) As you suggest have a suitable __be* et al. define when
   __KERNEL__ is not set.

Actually... What's the problem anyways?  #2 seems to already
be done.

In linux/types.h we have:

#ifdef __CHECKER__
#define __bitwise __attribute__((bitwise))
#else
#define __bitwise
#endif

typedef __u16 __bitwise __le16;
typedef __u16 __bitwise __be16;
typedef __u32 __bitwise __le32;
typedef __u32 __bitwise __be32;
#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
typedef __u64 __bitwise __le64;
typedef __u64 __bitwise __be64;
#endif

And this should just work.

That isn't even protected by __KERNEL__, it's fully visible to
userspace when you include linux/types.h
