From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Add seperated timeout for the connections that only receive
	packets in one direction
Date: Fri, 27 Nov 2009 17:59:32 +0800
Message-ID: <412e6f7f0911270159i2e55355end54b64372570b90d@mail.gmail.com>
References: <4B0F9737.8050606@gmail.com>
	 <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu>
	 <412e6f7f0911270132o3329843gab40f0c9a50620ae@mail.gmail.com>
	 <alpine.DEB.2.00.0911271036100.18988@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:54308 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZK0J70 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:59:26 -0500
Received: by pxi10 with SMTP id 10so1040728pxi.33
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2009 01:59:32 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.0911271036100.18988@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 27, 2009 at 5:42 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Fri, 27 Nov 2009, Changli Gao wrote:
>
>>
>> Yes, as nf_conntrack_tcp_timeout_loose_unreply implied, it is for
>> picked up connections.
>
> Connection pickup can be disabled by proper rules or by setting
> nf_ct_tcp_loose to zero. So in which environment this third method is
> required? I'm curious what triggered you to write your patch.
>

In some condition, you can't disable it. It's why we export
nf_ct_tcp_loose. As a bridge, if its booting breaks connections, users
won't happy, so we must allow loose mode.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
