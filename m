From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [SUBPATCH IPTABLES 0/43]: Unification of ip[6]tables
 matches/targets #3
Date: Fri, 20 Jul 2007 20:10:53 +0900 (JST)
Message-ID: <200707201110.l6KBArPX025309@toshiba.co.jp>
References: <200707170344.l6H3iVER007550@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707170344.l6H3iVER007550@toshiba.co.jp>
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


I've updated libxt_tcp and libxt_multiport according to comments from Jan.
This time I post only updated patches and the undeliverd patch in previous
time due to large patch.

[09-1/43] Fixed warning on compilation of iptables matches/targets
[09-2/43] Fixed warning on compilation of ip6tables matches/targets
[10/43] fixed warning on compilation, part 2
[17/43] Use unified API in multiport match.
[18/43] Split ipt_multport into family dependent parts and others
[19/43] Moves libipt_multiport.c to libxt_multiport.c
[20/43] Unifies libip[6]t_multiport.c into libipxt_multiport.c
[28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

> Well, I found missing FIN in text of help() in libipt_tcp.c then also
> fixed. New release is necessary again ? grrr..  If so, I'll change version
> in Makefile, and apply xtables patches to main trunk.

If no one wants new release again before commiting thse patches,
I'll commit them into main trunk without changing version in Makefile
next week (maybe Tuesday).

-- Yasuyuki Kozakai
