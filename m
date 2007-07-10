From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Patch for geoip to make it work with Linux kernel 2.6.22.x
Date: Tue, 10 Jul 2007 20:10:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707102009400.11053@fbirervta.pbzchgretzou.qr>
References: <twig.1177771162.67234@bugmachine.ca>
	<006801c7c309$2b8532a0$010210ac@BJERKESET.COM>
	<Pine.LNX.4.64.0707101839320.11053@fbirervta.pbzchgretzou.qr>
	<004a01c7c31b$d0427ca0$010210ac@BJERKESET.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jix@bugmachine.ca, netfilter-devel@lists.netfilter.org
To: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <004a01c7c31b$d0427ca0$010210ac@BJERKESET.COM>
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


On Jul 10 2007 19:57, Svein Olav Bjerkeset wrote:
>
> As for xt_register_match, it may have existed before 2.6.21, but as far as I
> can recall, it was not until 2.6.21 that ipt_register_match was removed, and
> geoip match compiled/worked with ipt_register_match until 2.6.21. I did not
> quite understand what you were saying about .family and xt_register_match?

'was saying that when using xt_register_match(), you _do_ need the ".family"
member in xt_match, because this is what ipt_register_match is:

#define ipt_register_match(x) \
	do { \
		(x)->family = AF_INET; \
		xt_register_match(x); \
	} while (0);


	Jan
-- 
