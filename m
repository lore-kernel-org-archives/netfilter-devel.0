From: =?gb2312?B?uN+35Q==?= <fgao@ikuai8.com>
Subject: RE: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear data access for TCP header
Date: Tue, 11 Apr 2017 08:59:31 +0800
Message-ID: <001201d2b25e$e1479340$a3d6b9c0$@ikuai8.com>
References: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com> <20170410120639.GA2386@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:35703 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdDKA7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 20:59:38 -0400
In-Reply-To: <20170410120639.GA2386@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Monday, April 10, 2017 8:07 PM
> To: gfree.wind@foxmail.com
> Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear
data access
> for TCP header
> 
> On Mon, Apr 10, 2017 at 06:36:03PM +0800, gfree.wind@foxmail.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > The current call path of nf_ct_tcp_seqadj_set is the following.
> >
> > nfqnl_recv_verdict->ctnetlink_glue_hook->ctnetlink_glue_seqadj
> > ->nf_ct_tcp_seqadj_set.
> >
> > It couldn't make sure the TCP header is in the linear data part.
> > So use the skb_header_pointer instead of the current codes.
> >
> > BTW, the nf_ct_tcp_seqadj_set is one external function of netfilter
> > which works in the network layer, it should not assume the transport
> > header is in the linear data.
> >
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  net/netfilter/nf_conntrack_seqadj.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_seqadj.c
> > b/net/netfilter/nf_conntrack_seqadj.c
> > index ef7063e..80394ab 100644
> > --- a/net/netfilter/nf_conntrack_seqadj.c
> > +++ b/net/netfilter/nf_conntrack_seqadj.c
> > @@ -61,11 +61,14 @@ void nf_ct_tcp_seqadj_set(struct sk_buff *skb,
> >  			  s32 off)
> >  {
> >  	const struct tcphdr *th;
> > +	struct tcphdr tcph;
> >
> >  	if (nf_ct_protonum(ct) != IPPROTO_TCP)
> >  		return;
> >
> > -	th = (struct tcphdr *)(skb_network_header(skb) + ip_hdrlen(skb));
> > +	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcph), &tcph);
> > +	if (!th)
> > +		return;
> 
> This fix is required since your recent upgrade to check for 4 bytes
instead of 8
> bytes from conntrack. Please confirm this.

Do you mean the commit e5e693ab49a95e1994979972eea224eefa81eba9 "netfilter:
conntrack: Only need first 4 bytes to get l4proto ports"?
Sorry, I could not figure out why it would break the rule, and cause issue.

Let's look at one change for TCP of that commit as following

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
b/net/netfilter/nf_conntrack_proto_tcp.c
index 70c8381..4abe9e1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -282,8 +282,8 @@ static bool tcp_pkt_to_tuple(const struct sk_buff *skb,
unsigned int dataoff,
        const struct tcphdr *hp;
        struct tcphdr _hdr;

-       /* Actually only need first 8 bytes. */
-       hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
+       /* Actually only need first 4 bytes to get ports. */
+       hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
        if (hp == NULL)
                return false;

The skb_header_pointer only copies the data, not make the data linear.
So I think it is ok after 4 bytes instead of 8 bytes.
It only affect the local variable, not the skb.

> 
> If so, it would be good to review the NAT code to see if there are more
spots
> that are not broken since that change...

I also check the other codes of Netfilter.

grep -in skb_network_header * in nf/net/netfilter and
nf/net/ipv4(6)/netfilter/
nf_nat_helper.c:41:     data = skb_network_header(skb) + dataoff;
nf_tables_core.c:99:            ptr = skb_network_header(skb) +
pkt->xt.thoff;
xt_TCPMSS.c:104:        tcph = (struct tcphdr *)(skb_network_header(skb) +
tcphoff);
xt_TCPMSS.c:163:                tcph = (struct tcphdr
*)(skb_network_header(skb) + tcphoff);
xt_TCPOPTSTRIP.c:54:    tcph = (struct tcphdr *)(skb_network_header(skb) +
tcphoff);
arpt_mangle.c:23:       arpptr = skb_network_header(skb) + sizeof(*arp);

all of them make sure the skb is linear, except the nf_tables_core.c which
use the skb_tail_pointer to exclude the non-linear data.

So there is only nf_ct_tcp_seqadj_set which need fixed.

Best Regards
Feng



