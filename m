From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH?] Fix getorigdst() in ip_conntrack_core.c on 2.4.22-ac2
Date: Wed, 10 Sep 2003 21:56:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309102151530.31287-100000@filer.marasystems.com>
References: <20030910133211.1360.qmail@web40908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Chapman <kakadu_croc@yahoo.com>
In-Reply-To: <20030910133211.1360.qmail@web40908.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Sep 2003, Brad Chapman wrote:

> Hi everyone!
> 
> gcc fails with the following error when compiling ip_conntrack_core.c on 2.4.22-ac2
> with gcc 3.2.2:

See my post a few days ago..

> +	struct ip_conntrack_tuple *tuple;

> +	IP_CT_TUPLE_BLANK(tuple);

Won't work.. the tuple needs to be allocated somewhere. If you make this 
change then you will cause random memory corruption or segmentation 
faults.

> gcc 3.2.2 compiles this properly with only a warning about the possiblity that
> tuple will be uninitialized. The original code looks perfectly legal and proper,
> so why would gcc 3.x fail?

Because the original code is not legal in any C compiler and should not be
accepted by any compiler, not only GCC 3.x (I am using RH GCC 2.96).  The
problem is the IP_CT_TUPLE_BLANK which is an incorrectly constructed
macro.

Regards
Henrik
