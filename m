From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 2/2] Cleanup returnvalues of protocolhandlers
Date: Mon, 20 Sep 2004 11:11:55 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0409201110040.12286@tux.rsn.bth.se>
References: <1095597972.8380.16.camel@tux.rsn.bth.se>
	<414DEEF0.8020508@trash.net> <414DEF2C.4040207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <414DEF2C.4040207@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 19 Sep 2004, Patrick McHardy wrote:

> Patrick McHardy wrote:
>
> > A couple of conversion where missing in ip_conntrack_proto_icmp.c,
> > I've added them to the patch. BTW: shouldn't we return CONNTRACK_INVALID
> > for all invalid icmp packets ? icmp_error returns CONNTRACK_INVALID for
> > these packets, icmp_error_message (after simple 1:1 conversion) returns
> > CONNTRACK_CONT.
>
> Oops, forgot to attach the new patch.

Bah, that's what you get for mostly hand editing other peoples patches :)

Please ignore this second patch, I'll send you an updated version after
I've gone through it properly and fixed the problems you noticed (and
other possible problems)

Thanks

/Martin
