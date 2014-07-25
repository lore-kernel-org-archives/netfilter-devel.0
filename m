From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nf: xt_LED: fix too short led-always-blink
Date: Fri, 25 Jul 2014 14:59:16 +0200
Message-ID: <20140725125916.GA13813@salvia>
References: <53A2AABD.8000109@aksignal.cz>
 <20140630105419.GA7671@localhost>
 <CAK5ve-Kc_Kv_EnenJSNA9J60QoTtH-zEjPowrOPuUrsWkh3ACQ@mail.gmail.com>
 <53D2055D.3040200@aksignal.cz>
 <20140725122212.GA5347@salvia>
 <53D2504A.20003@aksignal.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bryan Wu <cooloney@gmail.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, Richard Purdie <rpurdie@rpsys.net>,
	linux-leds@vger.kernel.org
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Return-path: <linux-leds-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D2504A.20003@aksignal.cz>
Sender: linux-leds-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2014 at 02:40:42PM +0200, Ji=C5=99=C3=AD Prchal wrote:
> If led-always-blink is set, then between switch led OFF and ON
> is almost zero time. So blink is invisible. This use oneshot led trig=
ger
> with fixed time 50ms witch is enough to see blink.
>=20
> Signed-off-by: Jiri <jiri.prchal@aksignal.cz>
>=20
> v2:
> defined constant XT_LED_BLINK_DELAY and use it instead of number

Strange, this doesn't apply. Perhaps your MUA is mangling the
attachment? Or using a very old tree as reference?

$ patch -p1 < /tmp/v2-nf-xt_LED-fix-too-short-led-always-blink.patch=20
patching file net/netfilter/xt_LED.c
Hunk #1 FAILED at 28.
Hunk #2 FAILED at 55.
Hunk #3 FAILED at 62.
3 out of 3 hunks FAILED -- saving rejects to file net/netfilter/xt_LED.=
c.rej
