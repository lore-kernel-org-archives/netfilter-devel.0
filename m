From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC] xt_layer7
Date: Sat, 4 Oct 2008 07:58:31 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Matthew Strait <quadong@users.sourceforge.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53137 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYJDL6c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:58:32 -0400
In-Reply-To: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-10-04 03:22, James King wrote:

>I've re-written xt_layer7 (l7-filter) so that it not longer requires
>patching of the nf_conn structure for data storage, using ct_extend
>instead, with the goal that it can eventually be used against a
>vanilla kernel with an unpatched iptables.

I had the same idea too a while back but put off on it - busy with
other iptables things :)

Right now, you still cannot use it with a vanilla kernel because
patches like #3 you attached enlarges the allocated region (remember,
NF_CT_EXT_NUM just increased by one!), which is going to be a big
impact {for users not using all the extensions} {if every imaginable
extensions adds itself a NF_CT_EXT_ number}.

Can someone think of a way to nicely fix this up? Like, a linked
list instead of the ct_extend[] array perhaps? Yes yes, that's not O(1),
but how many extensions at a time are you using anyway!

>One thing I haven't worked out is the following warning that results
>during a kernel compile now, any pointers on how to fix would be
>great:
>include/net/netfilter/nf_conntrack_acct.h:31: warning:
>nf_ct_acct_ext_add defined but not used

Add the "inline" keyword to the function header:

static inline
void *nf_ct_acct_ext_add( .....
