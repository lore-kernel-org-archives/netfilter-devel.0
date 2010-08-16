From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 22:26:58 +0800
Message-ID: <AANLkTikxcG8GpTTE5h28QSjD2uXpPXdNwFrshn2UKQRY@mail.gmail.com>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
 <1279285829.1603.77.camel@powerslave> <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
 <1279517423.7097.2.camel@powerslave> <1281966043.27200.30.camel@chilepepper>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47140 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0HPO1T convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:27:19 -0400
Received: by wyb32 with SMTP id 32so5756451wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2010 07:27:18 -0700 (PDT)
In-Reply-To: <1281966043.27200.30.camel@chilepepper>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 16, 2010 at 9:40 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
>
> Now that I have implemented the changes needed in the condition modul=
e
> so that it has a target which can be used to set the condition, I cam=
e
> up with the following rules to inform the userspace about the through=
put
> of a specific interface (in this case wlan0):
>
> iptables -N throughput
> iptables -N test_above
> iptables -N test_below
> iptables -A INPUT -i wlan0 -j throughput
> iptables -A OUTPUT -o wlan0 -j throughput
> iptables -A throughput -j RATEEST --rateest-name throughput --rateest=
-interval 250.0ms --rateest-ewmalog 500.0ms
> iptables -A throughput -m condition --name throughput ! --value 1 -j =
test_above
> iptables -A throughput -m condition --name throughput ! --value 2 -j =
test_below
> iptables -A test_above -m rateest --rateest1 throughput --rateest-bps=
1 0 --rateest-bps2 512bps --rateest-gt -j CONDITION --value 1 --name th=
roughput
> iptables -A test_above -m condition --name "throughput" --value 1 -j =
NFLOG --nflog-prefix "ABOVE "
> iptables -A test_below -m rateest --rateest1 throughput --rateest-bps=
1 0 --rateest-bps2 512bps --rateest-lt -j CONDITION --value 2 --name th=
roughput
> iptables -A test_below -m condition --name "throughput" --value 2 -j =
NFLOG --nflog-prefix "BELOW "
>
> This is just a proof of concept and I'm sure it can be optimized (I'l=
l
> look into it once it works fully).
>
> Anyway, my problem now, is that the rate estimator targets are only
> reached when there are packets coming through (for obvious reasons).
> What is happening is that, if the last packet sent through this
> interface is sent as part of a high throughput burst, the last signal
> the userspace will get is "ABOVE". =A0After that, the interface becom=
es
> idle and the "BELOW" signal is never sent, even though we will be
> transmitting at 0 bps.
>
> Does anyone have an idea on how I could solve this problem?
>
> I have been considering using the IDLETIMER target and activate it wh=
en
> the throughput goes to HIGH. =A0Then if this timer expires, it would
> inform the userspace that now there's no data going through. =A0But t=
his
> sounds very artificial to me and will add one more dependency on the
> userspace, since the IDLETIMER is using sysfs to inform userspace,
> instead of netlink.
>

Read the code of IDLETIMER again, and I notice that IDLETIMER will
wake up all the sleepers on the corresponding sysfs files. So no
polling is needed, what you need do is watching another files for
read. You can use select/poll/epoll. It should be no very difficult.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
