From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6] trivial: fix email address in MODULE_AUTHOR
Date: Tue, 02 Sep 2003 15:16:57 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030902064215.B286E2C0C9@lists.samba.org>
References: <20030830200504.GP17715@sunbeam.de.gnumonks.org>
Cc: David Miller <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-reply-to: Your message of "Sat, 30 Aug 2003 22:05:04 +0200."
             <20030830200504.GP17715@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030830200504.GP17715@sunbeam.de.gnumonks.org> you write:
> -MODULE_AUTHOR("Bart De Schuymer <bdschuy@pandora.be>");
> +MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
>  MODULE_DESCRIPTION("iptables bridge physical device match module");

There's no MODULE_AUTHOR at all in my tree..

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
