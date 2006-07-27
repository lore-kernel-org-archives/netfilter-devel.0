From: Patrick McHardy <kaber@trash.net>
Subject: Re: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Thu, 27 Jul 2006 16:00:01 +0200
Message-ID: <44C8C6E1.8010004@trash.net>
References: <44C89B2E.1080401@ufomechanic.net>
	<44C89DD8.7030103@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C89DD8.7030103@ufomechanic.net>
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

Amin Azez wrote:
> Not only is linux_nfnetlink_conntrack.h from SVN and not any kernel, it
> even ignores the kernel config so such ifdef's as:
> 
> enum ctattr_type {
>         CTA_UNSPEC,
>         CTA_TUPLE_ORIG,
>         CTA_TUPLE_REPLY,
>         CTA_STATUS,
>         CTA_PROTOINFO,
>         CTA_HELP,
>         CTA_NAT_SRC,
> #define CTA_NAT       CTA_NAT_SRC     /* backwards compatibility */
>         CTA_TIMEOUT,
>         CTA_MARK,
>         CTA_COUNTERS_ORIG,
>         CTA_COUNTERS_REPLY,
>         CTA_USE,
>         CTA_ID,
>         CTA_NAT_DST,
> #if defined(CONFIG_IP_NF_MATCH_LAYER7) ||
> defined(CONFIG_IP_NF_MATCH_LAYER7_MODULE)
>         CTA_L7,
> #endif /* LAYER7 */
> #ifdef CONFIG_IP_NF_CT_LINKLAYER
>         CTA_LINKLAYER,
> #endif /* LINKLAYER */
> ...
> ...
> ...

WTF is this? Its not from SVN, it appears the layer7 match does some
bad hacks here. It looks like a really dumb idea, this will break
once we add new attributes. Not sure why a match would need ctnetlink
attributes.
