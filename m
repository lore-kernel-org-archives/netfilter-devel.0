From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: ongoing textsearch/string match - 3 patches
Date: Thu, 22 Dec 2005 23:22:49 +0100
Message-ID: <43AB2739.6080608@eurodev.net>
References: <18730dc50512220611nfea98e2l88da4f25c97f341d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amir Goldstein <amir73il@gmail.com>
In-Reply-To: <18730dc50512220611nfea98e2l88da4f25c97f341d@mail.gmail.com>
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

Hi Amir,

Amir Goldstein wrote:
> I apologize that I am sending these patches directly to you,
> but I was not sure what is the policy of netfiler-devel list regarding
> sending patches.
> 
> I was hoping that you could help me with contributing these patches
> or with instructing me about the HOWTO of sending patches.

No need to worry. Basically, the policy is: send well-formed patches
together with a description of what you want to do and why you want to
do that. I've cc'ed the reply to netfilter-devel so everyone could
follow the discussion.

> I made these 3 patches to enable the string match netfilter
> to find a string that crosses the single packet boundaries.
> most of the work was to add ongoing textsearch support to Thomas's
> infrastructure.
> 
> Thanks for your time,
> Amir.
> 
> patches:
> ------------
> linux-2.6.14_ongoing-textsearch.patch:
> - add ongoing textsearch API to infrastructure (new/init/final/delete)
> - implement ongoing support for KMP textsearch algo
> - add /proc/textsearch entry to proc fs (lists loaded algos)
    ^^^
this can be useful.

> netfilter-2.6.14_ongoing-string-match.patch:
> - add ongoing support to string match info struct
> - use ongoing textsearch API when configured to do so
> 
> iptables-1.3.4_ongoing-string-match.patch:
> - add --ongoing option to string match iptables extension
> - use new string match info struct to pass args to kernel
> 
> test:
> ------
> I have tested ongoing string match using netcat UDP connection
> and it successfully matched the string:
> s
> tr
> ing

So, in this example, my understanding is that you want to find matchings
 splitted in several packets.

> which was sent in different 3 packets.
> the netcat test required using --from 28 to skip the udp header and
> some test code to ignore the new line characters.

I'm curious: We implement matching through fragments with KMP (not for
BM yet). So, what kind of application would require such pattern
matching policy?

> Index: linux-2.6.14/include/linux/netfilter_ipv4/ipt_string.h
> ===================================================================
> --- linux-2.6.14.orig/include/linux/netfilter_ipv4/ipt_string.h	2005-11-23 19:13:42.000000000 +0200
> +++ linux-2.6.14/include/linux/netfilter_ipv4/ipt_string.h	2005-11-23 19:16:38.000000000 +0200
> @@ -11,8 +11,10 @@
> 	char	  algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
> 	char 	  pattern[IPT_STRING_MAX_PATTERN_SIZE];
> 	u_int8_t  patlen;
> +	u_int8_t  ongoing;
> 	u_int8_t  invert;
> 	struct ts_config __attribute__((aligned(8))) *config;
> +	struct ts_state __attribute__((aligned(8))) *state;
>  };

Unfortunately, you can't do this. This would break backward
compatibility for previous versions of iptables. The correct way to do
this is using the matches/targets versioning (see ipt_MARK for an
example). We can revisit this later.

-- 
Pablo
