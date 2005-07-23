From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Rate limit
Date: Sat, 23 Jul 2005 13:14:07 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507231312490.13325@yvahk01.tjqt.qr>
References: <20050723045549.64791.qmail@web60815.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkata Narayana <mesg2nari@yahoo.com>
In-Reply-To: <20050723045549.64791.qmail@web60815.mail.yahoo.com>
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

>Hi All,
>
>Can i get any  developer documentation on rate limit
>module.

It is documented. See `man iptables`. If it does not show up there under the
section "limit", "dstlimit" or "hashlimit", check the POM-ng tree which
definitely does have the help texts.


Jan Engelhardt
-- 
