From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH resend] nf: xt_LED: fix too short led-always-blink
Date: Fri, 25 Jul 2014 16:11:23 +0200
Message-ID: <20140725141123.GA17926@salvia>
References: <945bac3162d5842491848f3d3ab43ba4c5fac157.1406291927.git.jiri.prchal@aksignal.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-leds@vger.kernel.org, rpurdie@rpsys.net, kaber@trash.net,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, cooloney@gmail.com
To: Jiri Prchal <jiri.prchal@aksignal.cz>
Return-path: <linux-leds-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <945bac3162d5842491848f3d3ab43ba4c5fac157.1406291927.git.jiri.prchal@aksignal.cz>
Sender: linux-leds-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2014 at 03:58:33PM +0200, Jiri Prchal wrote:
> From: Jiri <jiri.prchal@aksignal.cz>
> 
> If led-always-blink is set, then between switch led OFF and ON
> is almost zero time. So blink is invisible. This use oneshot led trigger
> with fixed time 50ms witch is enough to see blink.

Applied, thanks.

> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 993de2b..9c12f16 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -28,6 +28,8 @@
> 
>  #include <linux/netfilter/xt_LED.h>
> 
> +#define XT_LED_BLINK_DELAY 50 /* ms */

BTW, I moved this definition closer to scope where it is used, just for
readability reasons.
