From: Andreas Herz <andi@geekosphere.org>
Subject: Re: ip_route_output_key returns wrong gateway info with specific ip
 rules
Date: Mon, 12 May 2014 09:55:26 +0200
Message-ID: <20140512075526.GV10939@kvmbude>
References: <20140509134110.GI10939@kvmbude>
 <CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:59972 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaELHz2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 03:55:28 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Maciej,

thanks for your explanations!

On 10/05/14 at 02:56, Maciej =C5=BBenczykowski wrote:
> Easiest fix has been to use iptables mangle prerouting to mark
> packets, thus also forcing a reroute, and then using fwmark ip rules
> instead of (or maybe in addition to) from ip rules.

I can workaround this with marked packets etc., sure.  But i want to
know/learn why the "ip_route_output_key" from route.c function returns =
a
different value in my scenario although the data it gets via the
parameter is the same and just the ip rule is different.

I guess i have to add debug parts into route.c and dig more into that, =
i
just thought maybe some developer already knows what the problem might
be.

Thanks.

--=20
Andreas Herz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
