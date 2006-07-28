From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnfnetlink_conntrack encapsulation issues
Date: Fri, 28 Jul 2006 17:38:59 +0200
Message-ID: <44CA2F93.9000409@netfilter.org>
References: <44C89B2E.1080401@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C89B2E.1080401@ufomechanic.net>
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

Amin Azez wrote:
> I'm reworking some patches from conntrack 0.4.2 to the latest conntrack
> and I am getting badly bitten by a few problems of encapsulation and
> over seperation between user and kernel space.
>
> Problem 1:
> 
> One of my requirements is to combine CT_DUMP with CT_EVENT, so that I
> get regular events but also an inline dump based on a signal (blah blah
> blah). Inline (over the same socket) is important as it makes
> synchronzing the dump with events a little easier.
> 
> Of course most of this won't belong in libnetlink_conntrack but in some
> conntrack derivative, but the encapsulation of nfct_handle spoils this.
> 
> Specifically, I need such behaviours as requesting the conntrack table
> dump but without the nfnl_listen tacked on the end, for example
> (simplified fragment):
> 
> int nfct_dump_conntrack_table_request(struct nfct_handle *cth, int
> flags, int family)
> {
>         int err, msg;
>         struct nfnlhdr req;
> 
>         memset(&req, 0, sizeof(req));
>         /* This is not important until nfnl_listen we will set it again
> by then
>         cth->handler = nfct_conntrack_netlink_handler;
>         */
> 
>         msg = flags;
> 
>         nfnl_fill_hdr(cth->nfnlssh_ct, &req.nlh, 0, family, 0,
>                         msg,
> NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_DUMP);
> 
>         err = nfnl_send(cth->nfnlh, &req.nlh);
>         return err;
> }
> 
> int nfct_dump_event_conntrack(struct nfct_handle *cth, int family)
> {
>         struct sigaction sa;
>         struct sigaction oldint;
>         sa.sa_handler = signal_handler;
>         sigemptyset(&sa.sa_mask);
>         sa.sa_flags = 0;
> 
>         setlinebuf(stdout);
> 
>         sigaction(SIGUSR1, &sa, &oldint);
> 
>         if
> (nfct_dump_conntrack_table_requestl(cth,IPCTNL_MSG_CT_GET_CTRZERO_EXTRA,family)<0)
> {
>                 exit_error(OTHER_PROBLEM, "Can't request initial dump");
>                 break;
>         }
> 
>         /* Break this open later to do our own handler and own callback */
>         return nfct_event_conntrack(nfct_handle);
> }

The right thing here is not adding more crap API like this that makes 
very specific things. The problem with libnetfilter_conntrack is that at 
the time that I designed it I tried to hide as much netlink details as 
possible at that was an error.

I just send the patch attached to Patrick, since I can't commit to SVN 
anymore since my certificate expired. It provides low-level functions 
for those that want to work with libnfnetlink (or someday libnl) that is 
what I'm currently doing with conntrackd.

So libnetfilter_conntrack provides the set of specific functions to 
build netlink messages/attributes and you can use the low level 
communication layer that you prefer.

> Of course I'd rather do this duplicating as little of
> libnetlink_conntrack as possible, but this means libnetlink_conntrack
> needs to open up its primatives a lttle more. The reason I need my own
> handler too is because I'm sending back extra tuples including layer7
> information (I've submitted patches for this to the layer7 mailing list)
> 
> Also, as well as IPCTNL_MSG_CT_GET_CTRZERO in
> libnetfilter_conntrack/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
>  I have IPCTNL_MSG_CT_GET_CTRZERO_EXTRA, which is an alternate message
> to pass to the kernel to zero another class of counters.  Again, the
> libnetlink_conntrack library calls don't permit passing individual
> messages, making libnetlink_conntrack tightly coupled to a specific
> kernel and requiring that the kernel capabilities be known to
> libnetlink_conntrack - for example, do we need to change
> libnetlink_conntrack every time a new type of data can be dumped? (e.g.
> layer7?)
>
> Problem 2
> 
> autogen.sh
> 
> (mild issue first, not your fault anyway)
> 
> Of course my message is defined in my kernel headers which autogen.sh
> tries to copy accross - except that I am now using the make -o option
> for the kernel which means that build header files like autoconf.h,
> compile.h and version.h are linked to from /lib/modules/`uname -r`/build
> but none of the source header files are. For now I can copy the header
> file by hand but I wonder if anyone has a more general solution to this.
> I guess that the make process ought to write symlinks to any include
> dirs to the source.
> 
> However (big problems), when I make autogen copy my version of
> nfnetlink_conntrack.h, compiles fail on lack of: CTA_EXPECT_QUEUENR
> which I don't find available in any of the kernel sources I have; so
> which kernel is being tracked for libnetfilter_conntrack? The only
> useful reference google can find is a February chat session which
> indicates that linux_nfnetlink_conntrack.h is being kept in SVN so where
> does the idea of CTA_EXPECT_QUEUENR come from?

This is Harald's userspace helper stuff that is pending to be commited, 
since he's overloaded with work, I propose to remove it temporarily from 
SVN to avoid breaking things and take it back later once it gets commited.

> In fact I find that despite the assurances in autogen,sh,
> linux_nfnetlink_conntrack.h IS being kept in CVN and that the only
> solution the chatlogs recommend is to revert linux_nfnetlink_conntrack.h
> to the supplied one? What?
> 
> 
> I sometimes wonder if it is time to stop sharing enums like this between
> kernel and user space and make text labels out of them which
> applications can resolve into numbers by asking the kernel as they are
> executed.

enums are OK, the problem is out-of-tree scary things like this layer 7 
stuff that makes an insane use of libnetfilter_conntrack.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
