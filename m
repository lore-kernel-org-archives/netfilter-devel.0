From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] complete nfnl_talk
Date: Mon, 02 Jun 2003 21:31:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDBA604.9000109@trash.net>
References: <3EDB99E2.8050100@trash.net> <1054581106.1691.7.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1054581106.1691.7.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

Martin Josefsson wrote:

>Hi Patrick
>
>Good thing that you are fixing up this stuff.
>
>I have two patches that might be of interest. They are old and quite
>ugly...
>
>http://kashyyyk.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.diff
>Without this patch it's very easy for a regular user to cause a NULL
>pointer dereference. Harald has already included the kfree hunk in cvs
>but not the memset's.
>

I don't know if you've seen my changes to nfnetlink, i've added the memsets
to nfnetlink_check_attributes and changed ctnl_dump_table (iirc thats where
the kfree_skb was) quite a bit.

>http://kashyyyk.netfilter.org/~gandalf/patches/libctnetlink-020809-2.diff
>Change the ctnl_get_conntrack() interface a bit (incremental to my
>earlier fixes to that stuff).
>
>And finally the patch I use for oidentd
>http://kashyyyk.netfilter.org/~gandalf/patches/oidentd-2.0.3+cvs20020603-ctnetlink-diff
>Just here so people can see the interface.
>  
>

I have to get the source and patch it, i tried figuring out what exactly it
does from the diffs but didn't got it ;)

Thanks for the hints,
Patrick
