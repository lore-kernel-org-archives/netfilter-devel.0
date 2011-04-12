From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Netfilter Hook and Multiqueue?
Date: Tue, 12 Apr 2011 21:37:42 +0200
Message-ID: <1302637062.2811.3.camel@edumazet-laptop>
References: <BANLkTiku955Q-f=8T0K=qqY6i3tm5jFN_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42739 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1DLThv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:37:51 -0400
Received: by wya21 with SMTP id 21so5989360wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2011 12:37:50 -0700 (PDT)
In-Reply-To: <BANLkTiku955Q-f=8T0K=qqY6i3tm5jFN_w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 12 avril 2011 =C3=A0 12:21 -0700, Justin Yaple a =C3=A9crit :
> Hello,
>=20
> I am using a netfilter hook to capture "NF_IP_FORWARD" traffic and
> route packets to my application in userspace.  I want to implement
> more queues to distribute softirqs between multiple CPUs.  Is it
> currently possible to "return NF_QUEUE" with a specific queuenum or i=
s
> this handled automatically if I create more queue handlers in my
> application?
>=20

The key here is not NIC queue number but cpu number handling softirq

You can use cpu match added in linux 2.6.36, if you make sure all
packets for a given workflow are handled by an unique cpu

Say you have 4 cpus to handle the incoming load, you create 4 queues
and :

iptables -A FORWARD ... -m cpu 0 -j ...
iptables ... -m cpu 1 -j ...
iptables ... -m cpu 2 -j ...
iptables ... -m cpu 3 -j ...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
