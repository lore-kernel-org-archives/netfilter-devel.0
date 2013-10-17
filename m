From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: [PATCH iptables-nftables] nft: fix interface wildcard matching
Date: Thu, 17 Oct 2013 18:17:25 +0530
Message-ID: <CAEyr1FShn1LJX27pePQfTP_gjcRZ=cQvfiqd-5O021rn1M+-Nw@mail.gmail.com>
References: <1381932432-16754-1-git-send-email-pablo@netfilter.org>
	<CAEyr1FQtVEGHM0KD1qxDi6gLkVgrYhc0C46A2bPXE4nfewU-sQ@mail.gmail.com>
	<20131017084350.GA8423@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45068 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3JQMr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:47:27 -0400
Received: by mail-lb0-f169.google.com with SMTP id z5so1899546lbh.28
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2013 05:47:25 -0700 (PDT)
In-Reply-To: <20131017084350.GA8423@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 17, 2013 at 2:13 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 17, 2013 at 02:09:05PM +0530, Anand Raj Manickam wrote:
>> On Wed, Oct 16, 2013 at 7:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > In (73ea1cc nft: convert rule into a command state structure), the
>> > interface wildcard matching got broken. The previous handling was
>> > flawed by the use of ifnametoindex in scenario where the interface
>> > may vanished after a rule was added.
>> >
>> > This approach relies on the trailing '\0' to identify if this is
>> > an exact or wildcard matching, based on discussion with Florian.
>> >
>> > Based on initial patch from Anand Raj Manickam.
>> >
>> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> > ---
>> >  iptables/nft-shared.c |   38 ++++++++++++++++----------------------
>> >  1 file changed, 16 insertions(+), 22 deletions(-)
>> >
>> > diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
>> > index 3987f74..e0eaa17 100644
>> > --- a/iptables/nft-shared.c
>> > +++ b/iptables/nft-shared.c
>> > @@ -124,13 +124,11 @@ void add_iniface(struct nft_rule *r, char *iface, int invflags)
>> >         else
>> >                 op = NFT_CMP_EQ;
>> >
>> > -       if (iface[iface_len - 1] == '+') {
>> > -               add_meta(r, NFT_META_IIFNAME);
>> > +       add_meta(r, NFT_META_IIFNAME);
>> > +       if (iface[iface_len - 1] == '+')
>> >                 add_cmp_ptr(r, op, iface, iface_len - 1);
>> > -       } else {
>> > -               add_meta(r, NFT_META_IIF);
>> > -               add_cmp_u32(r, if_nametoindex(iface), op);
>> > -       }
>> > +       else
>> > +               add_cmp_ptr(r, op, iface, iface_len + 1);
>> >  }
>> >
>> >  void add_outiface(struct nft_rule *r, char *iface, int invflags)
>> > @@ -145,13 +143,11 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
>> >         else
>> >                 op = NFT_CMP_EQ;
>> >
>> > -       if (iface[iface_len - 1] == '+') {
>> > -               add_meta(r, NFT_META_OIFNAME);
>> > +       add_meta(r, NFT_META_OIFNAME);
>> > +       if (iface[iface_len - 1] == '+')
>> >                 add_cmp_ptr(r, op, iface, iface_len - 1);
>> > -       } else {
>> > -               add_meta(r, NFT_META_OIF);
>> > -               add_cmp_u32(r, if_nametoindex(iface), op);
>> > -       }
>> > +       else
>> > +               add_cmp_ptr(r, op, iface, iface_len + 1);
>> >  }
>> >
>> >  void add_addr(struct nft_rule *r, int offset,
>> > @@ -251,15 +247,14 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
>> >                         *invflags |= IPT_INV_VIA_IN;
>> >
>> >                 memcpy(iniface, ifname, len);
>> > -               iniface[len] = '\0';
>> >
>> > -               /* If zero, then this is an interface mask */
>> > -               if (if_nametoindex(iniface) == 0) {
>> > +               if (iniface[len] == '\0')
>> > +                       memset(iniface_mask, 0xff, len);
>> > +               else {
>> >                         iniface[len] = '+';
>> >                         iniface[len+1] = '\0';
>> > +                       memset(iniface_mask, 0xff, len + 1);
>> >                 }
>> > -
>> > -               memset(iniface_mask, 0xff, len);
>> >                 break;
>> >         case NFT_META_OIFNAME:
>> >                 ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
>> > @@ -267,15 +262,14 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
>> >                         *invflags |= IPT_INV_VIA_OUT;
>> >
>> >                 memcpy(outiface, ifname, len);
>> > -               outiface[len] = '\0';
>> >
>> > -               /* If zero, then this is an interface mask */
>> > -               if (if_nametoindex(outiface) == 0) {
>> > +               if (outiface[len] == '\0')
>> > +                       memset(outiface_mask, 0xff, len);
>> > +               else {
>> >                         outiface[len] = '+';
>> >                         outiface[len+1] = '\0';
>> > +                       memset(outiface_mask, 0xff, len + 1);
>> >                 }
>> > -
>> > -               memset(outiface_mask, 0xff, len);
>> >                 break;
>> >         default:
>> >                 DEBUGP("unknown meta key %d\n", key);
>>
>> Pablo,
>> This again breaks the delete functionality .
>
> This is working here with a fresh compilation:
>
> # xtables -I INPUT -i eth+
> # xtables -D INPUT -i eth+
> # xtables -I INPUT -i eth0
> # xtables -D INPUT -i eth0
>
> # which xtables
> /usr/sbin/xtables
> # ls -la /usr/sbin/xtables
> lrwxrwxrwx 1 root root 13 oct 17 10:42 /usr/sbin/xtables -> xtables-multi
>
> What problem are you noticing?
Sorry about it , i guess i had  the wrong build .. works great ..
Do you still want to maintain the refrence for  NFT_META_IIF / NFT_META_OIF ?
