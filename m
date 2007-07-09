From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Mon, 09 Jul 2007 17:29:35 +0200
Message-ID: <4692545F.2020101@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>	<468410A9.70309@trash.net>	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>	<4684ECB5.9070402@trash.net>	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>	<4688EF45.7020200@trash.net>	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>	<46891C50.1020904@trash.net>	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>	<468A2F91.3040002@trash.net>	<Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>	<468A3446.9050505@trash.net>	<Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>	<468BB421.3090801@trash.net>	<Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>	<468E3E06.3080305@trash.net>	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>	<46924678.9010909@trash.net>	<Pine.LNX.4.64
 .0707091700160.2887@fbirervta.pbzchgretzou.qr>
	<4692524B.3060403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4692524B.3060403@trash.net>
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

Patrick McHardy wrote:
> But I don't mind, this can also be changed afterwards. But I get
> rejects for some reason:
> 
> patching file include/linux/netfilter/xt_connlimit.h
> patching file net/netfilter/Kconfig
> Hunk #1 FAILED at 423.
> 1 out of 1 hunk FAILED -- saving rejects to file net/netfilter/Kconfig.rej
> patching file net/netfilter/Makefile
> Hunk #1 FAILED at 53.
> 1 out of 1 hunk FAILED -- saving rejects to file net/netfilter/Makefile.rej
> patching file net/netfilter/xt_connlimit.c
> 
> Please rediff against net-2.6.23.


My mistake. Applied, thanks Jan.
