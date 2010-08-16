From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables rule matching error
Date: Mon, 16 Aug 2010 22:29:07 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008162227430.5282@obet.zrqbmnf.qr>
References: <AANLkTin-QPu+vaZaRy62J80qwVbz1XiazCvi9iYZ1tR3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mistick Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40195 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab0HPU3I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:29:08 -0400
In-Reply-To: <AANLkTin-QPu+vaZaRy62J80qwVbz1XiazCvi9iYZ1tR3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-08-16 22:06, Mistick Levi wrote:
>
>I'm experiencing a problem with iptables...
>I add a rule to a chain with a few matches, and afterwards when i want
>to delete it, i must give it the exact order of matches i gave it
>before, otherwise it says it cant find the rule.
>
>Anyone else know this error? And if it's not an error, but there for
>performance, should'nt it be fixed?
>I'd like that change to be my first patch to iptables... so if you
>guys think the change is appropriate i'll get on it.
>
>Example:
>iptables -A FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
>-m udp --dport 555 -m physdev --physdev-out eth0
>iptables -D FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
>-m physdev --physdev-out eth0 -m udp --dport 555

These are not the same two rules. One evaluates the UDP header first,
the other evaluates the physdev interface first. Note that they are
evaluated in short-circuit fashion much like C expressions. Order is
important. This has implications for modules which update an internal
state.
