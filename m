From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Thu, 2 Jan 2003 19:34:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301021931270.8422-100000@dns.toxicfilms.tv>
References: <Pine.LNX.4.44.0301021150160.31237-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andras Kis-Szabo <kisza@securityaudit.hu>
In-Reply-To: <Pine.LNX.4.44.0301021150160.31237-100000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

The patch i send lately, has a nested comment which fails to compile
Like this:
/* bla
 * bla */
 */

Just need to remove the nested */ in the middle there.

It appears twice in include/linux/netfilter_ipv6/ip6t_HL.h in
the netfilter include directory and in the patch-o-matic kernel patch.

I can send a corrected version if necessary.


Regards,
Maciej Soltysiak
