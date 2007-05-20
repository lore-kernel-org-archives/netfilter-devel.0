From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack bug in snprintf_xml.c
Date: Sun, 20 May 2007 21:31:59 +0200
Message-ID: <4650A22F.2060502@netfilter.org>
References: <20070518194016.872D7A50020@pfepb.post.tele.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Morten Isaksen <misak@misak.dk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070518194016.872D7A50020@pfepb.post.tele.dk>
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

Morten Isaksen wrote:
> The port numbers are wrong in the XML output.
> 
> Index: src/conntrack/snprintf_xml.c
> ===================================================================
> --- src/conntrack/snprintf_xml.c        (revision 6832)
> +++ src/conntrack/snprintf_xml.c        (working copy)
> @@ -182,13 +182,13 @@
>         case IPPROTO_SCTP:
>                 if (type == __ADDR_SRC) {
>                         ret = snprintf(buf, len, "<sport>%u</sport>",
> -                                      tuple->l4src.tcp.port);
> +                                      htons(tuple->l4src.tcp.port));
                                          ^^^

Thanks for spotting this, I just committed a patch to fix this problem.
BTW, this should be ntohs, snprintf_default has the same stupid mistake.
Anyway this doesn't affect anything since ntohs and htons do the same :)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
