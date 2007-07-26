From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Thu, 26 Jul 2007 10:27:25 +0900 (JST)
Message-ID: <200707260127.l6Q1RPkq012082@toshiba.co.jp>
References: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
	<Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
	<36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	kaber@trash.net
To: indan@nul.nu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
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

From: "Indan Zupancic" <indan@nul.nu>
Date: Wed, 25 Jul 2007 19:41:45 +0200 (CEST)

> On Wed, July 25, 2007 19:13, Martin Josefsson wrote:
> > On Wed, 25 Jul 2007, Indan Zupancic wrote:
> >
> >>> Thanks. One more question: are you running nfs?
> >>
> >> Yes, but only for the host, I'm not using it locally. And it's v3, so should be
> >> using TCP. (rpc.mountd --no-nfs-version 1 --no-nfs-version 2.)
> >
> > I think it still uses UDP as default unless you specify tcp as a mount
> > option.
> 
> You're probably right, and think it the host isn't using the tcp option.
> 
> But I asked, and at the time the errors popped up NFS wasn't mounted.

I have one more question. Does that node receive ICMP error including
fragmented packet in its body ? I made ICMP error handling call
ipv4_get_l4proto in 2.6.23 tree.

-- Yasuyuki Kozakai
