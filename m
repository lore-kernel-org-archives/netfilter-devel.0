From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19
Date: Mon, 21 Jul 2003 13:22:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org>
 <20030701.024732.71580915.davem@redhat.com> <1057093550.720.58.camel@tux.rsn.bth.se>
 <20030721084011.8347162D3E@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-net@vger.kernel.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike Smith <mikesmith1@btconnect.com>
In-Reply-To: <20030721084011.8347162D3E@wlug.westbo.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jul 2003, Mike Smith wrote:

> > There's a small possibility that this is caused by the modify-after-free
> > bug that's fixed in 2.4.21 (but unfortunately introduced some
> > refcounting bugs, patches are on the way to Dave, they can be found in
> > netfilter patch-o-matic as well).
>
> Hi,
>
> this has happened again. Hand-transcribed oops below. Is this of interest?
> I'm happy to accept debug patches etc. Or shall I just move to 2.4.21?

I'll look over it again later tonight, in the mean time could you switch
to 2.4.21? And apply everything from submitted and pending in
patch-o-matic from cvs (cvs instructions can be found on
http://netfilter.org). Any eventual debugging-patches will be against that
kernel and those patches.

/Martin
