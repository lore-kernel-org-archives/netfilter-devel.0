From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Tue, 17 Jul 2007 12:44:29 +0900 (JST)
Message-ID: <200707170344.l6H3iVER007550@toshiba.co.jp>
References: <Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>
	<469A30E4.5060608@trash.net>
	<200707160831.l6G8VG8l014920@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707160831.l6G8VG8l014920@toshiba.co.jp>
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

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

> > > Since SYN+FIN does not make much sense (unless the ipv6-tcp protocol _really_
> > > allowed that), libipt_tcp's definition should be used.
> > 
> > 
> > Agreed, that should work fine for both.
> 
> OK, I don't come up with bad impact to current user, too.
> I'll fix that before applying xtables pathes.

Well, I found missing FIN in text of help() in libipt_tcp.c then also
fixed. New release is necessary again ? grrr..  If so, I'll change version
in Makefile, and apply xtables patches to main trunk.


-- Yasuyuki Kozakai
