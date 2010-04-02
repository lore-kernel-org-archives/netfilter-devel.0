From: agashi shipora <gashipo@gmail.com>
Subject: Re: br_netfilter post routing hook question...
Date: Fri, 2 Apr 2010 22:56:06 +0530
Message-ID: <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Gareth Williams <gwilliams@ubicom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45050 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0DBR0H convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:26:07 -0400
Received: by pva18 with SMTP id 18so971506pva.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Apr 2010 10:26:06 -0700 (PDT)
In-Reply-To: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I don't know if br_nf_post_routing can be assigned a priority
NF_BR_PRI_LAST-1. I couldn't find ip_refrag definition in 2.6.30.

As br_netfilter.c invokes the NF_INET_POST_ROUTING hook.I was thinking
if registering your module at NF_INET_POST_ROUTING (PF_INET) after
ipt_post_routing_hook(mangle table), nf_nat_out(nat table) and before
ipv4_confirm (conntrack) would help.

Ofcourse this would mean your module would come into picture for
routed packets too.

Thanks
GP

On Fri, Apr 2, 2010 at 7:48 PM, Gareth Williams <gwilliams@ubicom.com> =
wrote:
> Hello chaps.
>
> I have a module which hooks into the bridge on the post routing hook
> (PF_BRIDGE).
>
> I also enable bridge netfilter to allow iptables rules to process
> packets - I set rules on the post_routing chain (mangle table) to set
> marks on packets.
>
> Unfortunately I cannot see these marks in my code because the priorit=
y
> on the bridge_netfilter post routing hook is PRI_LAST.
>
> Since it is PRI_LAST I have no room to put my hook lower than it - so=
 I
> will never see these marks.
>
> The comment in br_netfilter.c for this hook says it has to be PRI_LAS=
T
> because ip_refrag() can return STOLEN - but does it really have to be
> LAST??? =A0Can't it be say, last-1 so I have at least some room to mo=
ve my
> module to see those marks?
>
> I know I could enable ebtables and do it that way but I am happy usin=
g
> the conntrack facilities within the iptables framework to monitor
> connections over the bridge. =A0The product I am working on also has
> limited power and adding yet another set of tables and hooks would ju=
st
> cause more slowdown in the fast path - something I don't think we can
> stand right now.
>
> Am I missing something obvious?
>
> Cheers for any advice.
>
> Gareth
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
