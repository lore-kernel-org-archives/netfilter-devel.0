From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.4] netfilter ipt_conntrack/ipt_state moduse count
Date: Tue, 03 Feb 2004 11:42:01 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203010224.387392C13E@lists.samba.org>
References: <20040202152149.GG24449@obroa-skai.de.gnumonks.org>
Cc: Sergey Vlasov <vsu@altlinux.ru>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-reply-to: Your message of "Mon, 02 Feb 2004 16:21:49 BST."
             <20040202152149.GG24449@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20040202152149.GG24449@obroa-skai.de.gnumonks.org> you write:
> ip_nat_standalone.c : is using conntrack functions anyway

IIRC, this wasn't always the case, especially on UP (where the
conntrack lock vanishes).

If it is the case now, we're OK.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
