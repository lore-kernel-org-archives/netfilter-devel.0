From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Add seperated timeout for the connections that only receive
	packets in one direction
Date: Fri, 27 Nov 2009 17:32:53 +0800
Message-ID: <412e6f7f0911270132o3329843gab40f0c9a50620ae@mail.gmail.com>
References: <4B0F9737.8050606@gmail.com>
	 <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:32853 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZK0Jcr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:32:47 -0500
Received: by pwi3 with SMTP id 3so898965pwi.21
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2009 01:32:53 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 27, 2009 at 5:25 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> Hi,
>
> On Fri, 27 Nov 2009, Changli Gao wrote:
>
>
> I don't see how can the condition be true. The first reply
> packet checked here and if that's a pure ACK, then the new_state cann=
ot be
> TCP_CONNTRACK_ESTABLISHED (except for picked up connections).
>

Yes, as nf_conntrack_tcp_timeout_loose_unreply implied, it is for
picked up connections.


--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
