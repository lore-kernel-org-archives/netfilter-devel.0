From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V4 1/2] netfilter: xt_AUDIT: use consistent ipv4 network
	offset
Date: Wed, 22 Mar 2017 07:43:18 -0400
Message-ID: <20170322114318.GC9021@madcap2.tricolour.ca>
References: <d2ef98ddd4884276879107d4cd4521330e709578.1490165887.git.rgb@redhat.com>
	<20170322111151.GA2766@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, linux-audit@redhat.com,
	Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
	Thomas Woerner <twoerner@redhat.com>, Thomas Graf <tgraf@infradead.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170322111151.GA2766@salvia>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 2017-03-22 12:11, Pablo Neira Ayuso wrote:
> On Wed, Mar 22, 2017 at 03:05:36AM -0400, Richard Guy Briggs wrote:
> > Even though the skb->data pointer has been moved from the link layer
> > header to the network layer header, use the same method to calculate the
> > offset in ipv4 and ipv6 routines.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  net/netfilter/xt_AUDIT.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> > index 4973cbd..cdb7cee 100644
> > --- a/net/netfilter/xt_AUDIT.c
> > +++ b/net/netfilter/xt_AUDIT.c
> > @@ -76,7 +76,7 @@ static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> >  	struct iphdr _iph;
> >  	const struct iphdr *ih;
> >  
> > -	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> > +	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
> 
> This update is completely pointless.

Its point is to be consistent with audit_ip6() and to prevent further
time consumed by confusion and head-scratching.  I know it is slightly
slower with an identical result.

> If you want I can place it in nf-next, your call.

I'd prefer to bring it through the audit-next tree to avoid the merge
conflict.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
