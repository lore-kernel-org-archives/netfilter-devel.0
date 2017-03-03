From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Thu, 2 Mar 2017 21:00:07 -0500
Message-ID: <20170303020007.GF18258@madcap2.tricolour.ca>
References: <044a666e507a829f8c1d6dcc19ad78cd9f140ddd.1488142060.git.rgb@redhat.com>
	<CAHC9VhTUSz-tyPyZ7PJAH08sfhuACeUTkEKEnnwM_axQ4UdorQ@mail.gmail.com>
	<20170301162802.GV18258@madcap2.tricolour.ca>
	<CAHC9VhTHfyPR-yj4kOAJBeU4D1=o4Uu-=S_STvQoj4OAr9Y-mQ@mail.gmail.com>
	<20170301223447.GA18258@madcap2.tricolour.ca>
	<CAHC9VhRGSzea_c9Gg-Z3gr8cu2UQA9DhNtba0tf9AShoNakxzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Woerner <twoerner@redhat.com>, linux-audit@redhat.com,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRGSzea_c9Gg-Z3gr8cu2UQA9DhNtba0tf9AShoNakxzw@mail.gmail.com>
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

On 2017-03-02 19:16, Paul Moore wrote:
> On Wed, Mar 1, 2017 at 5:34 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2017-03-01 17:19, Paul Moore wrote:
> >> On Wed, Mar 1, 2017 at 11:28 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > On 2017-02-28 17:22, Paul Moore wrote:
> >> >> On Sun, Feb 26, 2017 at 3:49 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > Eliminate flipping in and out of message fields, dropping fields in the process.
> >> >> >
> >> >> > Sample raw message format IPv4 UDP:
> >> >> > type=NETFILTER_PKT msg=audit(1487874761.386:228):  mark=0xae8a2732 saddr=127.0.0.1 daddr=127.0.0.1 proto=17^]
> >> >> > Sample raw message format IPv6 ICMP6:
> >> >> > type=NETFILTER_PKT msg=audit(1487874761.381:227):  mark=0x223894b7 saddr=::1 daddr=::1 proto=58^]
> >> >> >
> >> >> > Issue: https://github.com/linux-audit/audit-kernel/issues/11
> >> >> > Test case: https://github.com/linux-audit/audit-testsuite/issues/43
> >> >> >
> >> >> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >> >> > ---
> >> >> >  net/netfilter/xt_AUDIT.c |  122 ++++++++++-----------------------------------
> >> >> >  1 files changed, 27 insertions(+), 95 deletions(-)
> >> >> >
> >> >> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> >> >> > index 4973cbd..945fa29 100644
> >> >> > --- a/net/netfilter/xt_AUDIT.c
> >> >> > +++ b/net/netfilter/xt_AUDIT.c
> >> >> > @@ -31,146 +31,78 @@ MODULE_ALIAS("ip6t_AUDIT");
> >> >>
> >> >> ...
> >> >>
> >> >> > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> >> >> > +static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> >> >> >  {
> >> >> >         struct iphdr _iph;
> >> >> >         const struct iphdr *ih;
> >> >> >
> >> >> >         ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> >> >>
> >> >> It seems like we should be using skb_network_offset(skb) instead of 0
> >> >> above, yes?  Granted, this isn't new, but let's fix it.
> >> >
> >> > Yes, I agree.  How does this even work now?  Maybe the MAC header hasn't
> >> > been added yet (or has already been processed and stripped off) so that
> >> > skb->data is already pointing at the network header and hence has an
> >> > offset of 0.  Can you be more explicit and elaborate to say if this what
> >> > you were thinking?
> >>
> >> Unfortunately, not really, I haven't thought through of all the
> >> situations and it has been a long time since I've had to worry about
> >> things like this.  I think we are in agreement that it needs to
> >> change, so let's just make the change.
> >
> > Given Pablo's assurances, this could go either way, fix audit_ip4 to use
> > skb_network_offset() or fix audit_ip6 to use zero.  I don't have a
> > strong opinion, but using zero would be more efficient while using
> > skb_network_offset() would remove the doubt.  Either way, the
> > consistency will avoid raising doubt in the future as you have
> > (rightfully) done.
> 
> Just use skb_network_offset() as it is the safer option and there is
> plenty of precedence.  Considering that we expect NETFILTER_PKT to see
> limited use, I'm more concerned about it not breaking than some small
> loss of performance.

Agreed.

> >> >> >  static unsigned int
> >> >> >  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
> >> >> >  {
> >> >> > -       const struct xt_audit_info *info = par->targinfo;
> >> >> >         struct audit_buffer *ab;
> >> >> > +       int fam = -1;
> >> >> >
> >> >> >         if (audit_enabled == 0)
> >> >> >                 goto errout;
> >> >> > -
> >> >> >         ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> >> >> >         if (ab == NULL)
> >> >> >                 goto errout;
> >> >> >
> >> >> > -       audit_log_format(ab, "action=%hhu hook=%u len=%u inif=%s outif=%s",
> >> >> > -                        info->type, par->hooknum, skb->len,
> >> >> > -                        par->in ? par->in->name : "?",
> >> >> > -                        par->out ? par->out->name : "?");
> >> >> > -
> >> >> > -       if (skb->mark)
> >> >> > -               audit_log_format(ab, " mark=%#x", skb->mark);
> >> >> > -
> >> >> > -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> >> >> > -               audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
> >> >> > -                                eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
> >> >> > -                                ntohs(eth_hdr(skb)->h_proto));
> >> >> > +       audit_log_format(ab, "mark=%#x", skb->mark ?: -1);
> >> >>
> >> >> How do Steve's userspace tools like the unset/-1 value represented
> >> >> when it is a hex value: -1 or 0xffffffff?
> >> >
> >> > My understanding is they are set up to cope with this.
> >>
> >> How does userspace distinguish between an unset nfmark and a nfmark of
> >> 0xffffffff?
> >
> > It never had to deal specifically with nfmark previously because it
> > wasn't included if it was blank.  Generally other values that are -1 are
> > interpreted by the audit userspace tools as unset (session id, auid,
> > etc...)
> 
> Yes, I know, let me get straight to the point: should we use "mark=-1"
> when the nfmark is unset instead of "mark=0xffffffff"?

I'd prefer to keep the format as it was, explicitly labelled hex.  The
other fields that are printed as unset, -1, come out in the logs as
MAX_UINT: "auid=4294967295 ses=4294967295", so I don't see any reason to
change that convention.  Once that field is known by userspace tools,
they can interpret (-i) that as -1.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
