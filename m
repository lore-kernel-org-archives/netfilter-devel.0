From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 12_contrack_nat_dependency.patch
Date: Thu, 27 Mar 2003 13:24:39 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030327041148.0DA5E2C056@lists.samba.org>
References: <1048630711.14738.71.camel@tux.rsn.bth.se>
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-reply-to: Your message of "25 Mar 2003 23:18:32 BST."
             <1048630711.14738.71.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <1048630711.14738.71.camel@tux.rsn.bth.se> you write:
> Hi Rusty,
> 
> I have a question about the 12_contrack_nat_dependency.patch in
> p-o-m/pending...
> 
> The patch you sent Harald was for 2.5, will a similar patch work for
> 2.4? I've backported it and it compiles but I can't really test it.

Yep, should be fine.  It has a flaw though for UP, in that relying on
the lock is not sufficient.

Harald and I are arguing it now; I'll tell you the answer when we
have it.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
