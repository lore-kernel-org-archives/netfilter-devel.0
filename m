From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 00:36:55 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4159E787.4080209@trash.net>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040928220532.GN29961@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>The conntrack message basically means that at NF_IP_PRE_ROUTING we
>suddenly see fragmented packets.  This "can never happen" since at the
>same PRE_ROUTING hook we defragment just before
>via ip_conntrack_defrag() -> ip_ct_gather_frags() -> ip_defrag()
>
>Big question number 2:
>How can a fragment survive ip_defrag() ?
>

Pretty simple:

static unsigned int ip_conntrack_defrag(unsigned int hooknum,
                                        struct sk_buff **pskb,
                                        const struct net_device *in,
                                        const struct net_device *out,
                                        int (*okfn)(struct sk_buff *))
{
        /* Previously seen (loopback)?  Ignore.  Do this before
           fragment check. */
        if ((*pskb)->nfct)
                return NF_ACCEPT;

I'll send a patch later.

Regards
Patrick
