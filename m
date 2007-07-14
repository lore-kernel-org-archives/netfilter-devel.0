From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/43] fixed warning on compilation, part 2
Date: Sat, 14 Jul 2007 20:38:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707142037540.25352@fbirervta.pbzchgretzou.qr>
References: <200707141723.l6EHNSTk026048@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707141723.l6EHNSTk026048@toshiba.co.jp>
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


On Jul 15 2007 02:23, Yasuyuki KOZAKAI wrote:
>@@ -135,8 +135,9 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
> }
> 
> static const char *
>-check_proto(const struct ip6t_entry *entry)
>+check_proto(const void *e)
> {
>+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;

Conversion from/to void* does not require a cast. (also elsewhere)


	Jan
-- 
