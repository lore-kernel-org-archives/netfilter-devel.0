From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [ANNOUNCE] Release of iptables 1.3.8
Date: Fri, 29 Jun 2007 00:46:13 +0900 (JST)
Message-ID: <200706281546.l5SFkETa022678@toshiba.co.jp>
References: <4680DAB6.9000903@trash.net>
	<200706281139.l5SBduIn016853@toshiba.co.jp>
	<4683A117.8000309@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, david@blue-labs.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4683A117.8000309@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 28 Jun 2007 13:52:55 +0200

> Yasuyuki KOZAKAI wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Tue, 26 Jun 2007 11:21:58 +0200
> >> Indeed, thanks for the reminder. The KERNEL_64_USERSPACE_32 stuff
> >> needs to go.
> >>
> >> Patches for that are welcome.
> >>     
> >
> > How state on this is ? If anyone doesn't do it until I come from dinner,
> > I'll take it. It conflicts some of xtasble patches I've updated.
> 
> I don't think anyone is working on it so far.

Done to commit. But I didn't kill KERNEL_64_USERSPACE_32 from Makefile,
SAME, and CLUSTERIP. They doesn't have compat layer in kernel
in the current.

-- Yasuyuki Kozakai
