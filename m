From: Patrick McHardy <kaber@trash.net>
Subject: Re: Concurrency issues with the iptables
	userspace	program	andexitcodes
Date: Mon, 19 Jun 2006 18:29:14 +0200
Message-ID: <4496D0DA.6030300@trash.net>
References: <1149153349.28481.15.camel@localhost.localdomain>	<447F1227.7050900@trash.net>	<Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>	<447F5204.4080505@trash.net>	<1149771143.28481.87.camel@localhost.localdomain>	<44901796.6040000@trash.net>
	<1150296040.26187.114.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@comx.dk>
In-Reply-To: <1150296040.26187.114.camel@localhost.localdomain>
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

Jesper Dangaard Brouer wrote:
> Hmmm... I though I did include it inline below my signature... well lets
> try again...This time I also attach it as a file attachment.

Applied, thanks. I got a reject on the libiptc part, so I just left
it out.

> diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptables-1.3.4-pom-l7/libiptc/libiptc.c iptables-1.3.4-pom-l7-blocking/libiptc/libiptc.c
> --- iptables-1.3.4-pom-l7/libiptc/libiptc.c	2005-10-31 20:03:49.000000000 +0100
> +++ iptables-1.3.4-pom-l7-blocking/libiptc/libiptc.c	2006-06-07 10:25:02.000000000 +0200
> @@ -2104,6 +2104,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
>  		free(repl->counters);
>  		free(repl);
>  		free(newcounters);
> +		// The "EAGAIN: Resource temporarily unavailable" occurs here.
>  		return 0;
>  	}
>  
