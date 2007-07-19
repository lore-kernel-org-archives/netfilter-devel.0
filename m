From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: xt_TARPIT
Date: Thu, 19 Jul 2007 08:49:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707190846470.20544@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
	<469EB401.8000700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	safari-netfilter@safari.iki.fi,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469EB401.8000700@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Jul 2007, Patrick McHardy wrote:

> I don't really like adding a notrack reference in the TARPIT target
> though, I would prefer to use the one from the original packet (as in
> REJECT) and for NOTRACK you would simply mark the original packet.

That's better, indeed. And later we'll be able to say

  <match evil source> -j NOTRACK -j TARPIT

:-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
