From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 08/11] Remove ASSERT_{READ,WRITE}_LOCK
Date: Fri, 3 Nov 2006 13:32:05 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031329570.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.306515682@wlug.westbo.se>
	<454B3532.9090701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B3532.9090701@trash.net>
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

On Fri, 3 Nov 2006, Patrick McHardy wrote:

> Martin Josefsson wrote:
> > Remove the usage of ASSERT_READ_LOCK/ASSERT_WRITE_LOCK in x_tables and
> > nf_conntrack, it didn't do anything, it was just an empty define and it
> > uglified the code.
>
> Fully agreed. I kept them mainly in case something similar would
> show up for kernel-wide use, but it doesn't looks that way and
> I stronly believe that readability helps a lot more to catch bugs.
>
> BTW, the patch doesn't touch any x_tables files, did you forgot
> to commit them?

I forgot to change the description when I ported the patch to a newer
kernel where I think x_tables already had them removed. (my laptop with
the kernel trees is suspended at home right now)

/Martin
