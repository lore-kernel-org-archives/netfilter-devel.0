From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Wed, 1 Mar 2017 17:19:27 -0500
Message-ID: <CAHC9VhTHfyPR-yj4kOAJBeU4D1=o4Uu-=S_STvQoj4OAr9Y-mQ@mail.gmail.com>
References: <044a666e507a829f8c1d6dcc19ad78cd9f140ddd.1488142060.git.rgb@redhat.com>
	<CAHC9VhTUSz-tyPyZ7PJAH08sfhuACeUTkEKEnnwM_axQ4UdorQ@mail.gmail.com>
	<20170301162802.GV18258@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Woerner <twoerner@redhat.com>, linux-audit@redhat.com,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170301162802.GV18258@madcap2.tricolour.ca>
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

On Wed, Mar 1, 2017 at 11:28 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-28 17:22, Paul Moore wrote:
>> On Sun, Feb 26, 2017 at 3:49 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > Eliminate flipping in and out of message fields, dropping fields in the process.
>> >
>> > Sample raw message format IPv4 UDP:
>> > type=NETFILTER_PKT msg=audit(1487874761.386:228):  mark=0xae8a2732 saddr=127.0.0.1 daddr=127.0.0.1 proto=17^]
>> > Sample raw message format IPv6 ICMP6:
>> > type=NETFILTER_PKT msg=audit(1487874761.381:227):  mark=0x223894b7 saddr=::1 daddr=::1 proto=58^]
>> >
>> > Issue: https://github.com/linux-audit/audit-kernel/issues/11
>> > Test case: https://github.com/linux-audit/audit-testsuite/issues/43
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> > ---
>> >  net/netfilter/xt_AUDIT.c |  122 ++++++++++-----------------------------------
>> >  1 files changed, 27 insertions(+), 95 deletions(-)
>> >
>> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
>> > index 4973cbd..945fa29 100644
>> > --- a/net/netfilter/xt_AUDIT.c
>> > +++ b/net/netfilter/xt_AUDIT.c
>> > @@ -31,146 +31,78 @@ MODULE_ALIAS("ip6t_AUDIT");
>>
>> ...
>>
>> > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
>> > +static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
>> >  {
>> >         struct iphdr _iph;
>> >         const struct iphdr *ih;
>> >
>> >         ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
>>
>> It seems like we should be using skb_network_offset(skb) instead of 0
>> above, yes?  Granted, this isn't new, but let's fix it.
>
> Yes, I agree.  How does this even work now?  Maybe the MAC header hasn't
> been added yet (or has already been processed and stripped off) so that
> skb->data is already pointing at the network header and hence has an
> offset of 0.  Can you be more explicit and elaborate to say if this what
> you were thinking?

Unfortunately, not really, I haven't thought through of all the
situations and it has been a long time since I've had to worry about
things like this.  I think we are in agreement that it needs to
change, so let's just make the change.

> This should be a seperate bug fix patch rather than fixing it in the
> noise of this substantial re-arrangement.

That's fine, but please send it as one patchset.  Also, to get ahead
of the next likely question, no I don't think the skb_network_offset()
fix is -stable worthy at the moment.

>> > -       if (!ih) {
>> > -               audit_log_format(ab, " truncated=1");
>> > -               return;
>> > -       }
>> > +       if (!ih)
>> > +               return false;
>> >
>> > -       audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
>> > -               &ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);
>> > +       audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
>> > +                        &ih->saddr, &ih->daddr, ih->protocol);
>> >
>> > -       if (ntohs(ih->frag_off) & IP_OFFSET) {
>> > -               audit_log_format(ab, " frag=1");
>> > -               return;
>> > -       }
>> > -
>> > -       audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
>> > +       return true;
>> >  }
>>
>> ...
>>
>> >  static unsigned int
>> >  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
>> >  {
>> > -       const struct xt_audit_info *info = par->targinfo;
>> >         struct audit_buffer *ab;
>> > +       int fam = -1;
>> >
>> >         if (audit_enabled == 0)
>> >                 goto errout;
>> > -
>> >         ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>> >         if (ab == NULL)
>> >                 goto errout;
>> >
>> > -       audit_log_format(ab, "action=%hhu hook=%u len=%u inif=%s outif=%s",
>> > -                        info->type, par->hooknum, skb->len,
>> > -                        par->in ? par->in->name : "?",
>> > -                        par->out ? par->out->name : "?");
>> > -
>> > -       if (skb->mark)
>> > -               audit_log_format(ab, " mark=%#x", skb->mark);
>> > -
>> > -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
>> > -               audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
>> > -                                eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
>> > -                                ntohs(eth_hdr(skb)->h_proto));
>> > +       audit_log_format(ab, "mark=%#x", skb->mark ?: -1);
>>
>> How do Steve's userspace tools like the unset/-1 value represented
>> when it is a hex value: -1 or 0xffffffff?
>
> My understanding is they are set up to cope with this.

How does userspace distinguish between an unset nfmark and a nfmark of
0xffffffff?

--
paul moore
www.paul-moore.com
