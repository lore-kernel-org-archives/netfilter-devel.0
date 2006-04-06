From: Jones Desougi <jones@ingate.com>
Subject: Re: [NETFILTER 01/12]: Add helper functions for mass hook
	registration/unregistration
Date: Thu, 6 Apr 2006 17:42:27 +0200
Message-ID: <200604061542.k36FgRVL032443@usagi.ingate.se>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100453.17409.47998.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-reply-to: <20060406100453.17409.47998.sendpatchset@localhost.localdomain>
	(message from Patrick McHardy on Thu, 6 Apr 2006 12:04:53 +0200
	(MEST))
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

> +err:
> +	if (i > 0)
> +		nf_unregister_hooks(reg, i - i);
                                         ^^^^^
> +	return err;
> +}

That should make it a nice noop. :-)
Change the line to:
+		nf_unregister_hooks(reg, i);

     /Jones
