From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] ipt_dstlimit spinlock fixup
Date: Mon, 23 Aug 2004 13:12:31 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040823201231.GA2046@linuxace.com>
References: <20040822153348.GA20301@linuxace.com> <412A3BAA.6000708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <412A3BAA.6000708@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 23, 2004 at 08:47:06PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> 
> >Since ipt_dstlimit makes use of MUST_BE_LOCKED macro, compiling
> >without CONFIG_NETFILTER_DEBUG causes errors.  Fix below.
> >
> Jozsefs conntrack_locking patch has the same problem, I wonder if we
> should introduce a spinlock_debug_t (if that is not taken yet) or
> better yet, kill lockhelp.h.

Or option 3: remove the MUST_BE_LOCKED users in both files.  lockhelp
does seem to be, er, helpful in some cases.

Phil
