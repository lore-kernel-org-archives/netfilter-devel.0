From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 2/2] kill unnecessary ntohs to compare
 tuples
Date: Mon, 29 Aug 2005 21:38:34 +0900 (JST)
Message-ID: <200508291238.j7TCcYYj008545@toshiba.co.jp>
References: <200508161011.j7GABxcg028632@toshiba.co.jp>
	<20050826110732.GR4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050826110732.GR4226@rama.de.gnumonks.org>
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


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 26 Aug 2005 13:07:32 +0200

> > This patch kills unnecessary ntohs() in nf_ct_tuple_mask_cmp(). If we need to
> > take care about byte order here, should use ntohl(). This bug was introduced
> > when I changed size of 'all' from 16bits to 32bits. But in the first place,
> > it's not necessary to do that because the byte order of all arguments are
> > same.
> 
> thanks, applied.
> 
> Two comments though:
> 
> 0) why was it made 32bit?

just for efficiency on 32bit architectures.

> 1) I think some of the debug print macros in nf_conntrack_tuple.h still
>    have the '16bit assumption' and use ntohs.

Well, this macro applies ntohs() to 16bits variable, so there is no problem,
I think. On the other hand, above bug applies ntohs() to 32bits variable.
I don't know why error was not occurred on compilation.

> 2) I think we could and probably should cleanup the include paths.  The
>    general policy seems to be that include/net/* is kernel-only, and
>    include/linux/* is stuff that needs to be exposed to userspace.
>    Since userspace has no reason to know about lots of the internals, we
>    could move files like nf_conntrack_tuple.h to a newly-created
>    include/net/netfilter/ directory.  I'm not yet sure whether that's a
>    good idea or not.  Anyway, a good intermediate step might be to add 
>    "#ifdef __KERNEL__" sections to all those sections of nf_conntrack
>    header files that are never used from userspace.

I agree with you.

>From the past changes, e.g. "dir" in tuple, we learned that non-standardized
structures which might be changed in the future should not be included from
user program.

Which files should be left ? In the current, some extensions of iptables
use linux/ip_conntrack.h and linux/ip_conntrack_tuple.h for enums.
In the nf_conntrack tree, these are defined in nf_conntrack_*_common.h.
Then I think we can move the other header files.

BTW, it might be preferable to rename nf_conntrack_*_common.h to
nf_conntrack_*_compat.h and move them to linux/netfilter_ipv4.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
