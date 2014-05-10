From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: ip_route_output_key returns wrong gateway info with specific ip rules
Date: Sat, 10 May 2014 02:56:17 -0700
Message-ID: <CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
References: <20140509134110.GI10939@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:51959 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaEJJ4S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2014 05:56:18 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so5742002qcr.20
        for <netfilter-devel@vger.kernel.org>; Sat, 10 May 2014 02:56:17 -0700 (PDT)
In-Reply-To: <20140509134110.GI10939@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(guesswork, read it with a grain of salt)

In my experience stuff like this usually ends up being caused by the
order in which src ip selection (for locally generated packets without
an explicit bind(ip) call, but thus also src ip selection for auto
nat), route lookup and nat happen.
Easiest fix has been to use iptables mangle prerouting to mark
packets, thus also forcing a reroute, and then using fwmark ip rules
instead of (or maybe in addition to) from ip rules.

In your particular case I'm guessing the route lookup is happening
post-source-nat src ip substitution (or even with a 0 during nat sec
ip selection).  While theoretically SNAT happens in POSTROUTING, and
thus after routing, I think this is only truly the case for the first
packet of a flow.

To be fair my info may be long obsolete, since I most recently (1-2
weeks ago) ran into something like this on some 2.4 kernel (wrt54gl
openwrt 8.09.2) while trying to use a different src ip for SNAT to
port 80/443 then for all other ports.
In my case iptables mangle prerouting (ip rule fwmark lookup) was used
to mark SYNs from local client ip to dest port 80/443, and then src ip
routing (ip rule from X) worked for everything else (ie. the rest of
the tcp connection).
Although that was with dst port based SNAT rules and not MASQUERADE.

- Maciej
