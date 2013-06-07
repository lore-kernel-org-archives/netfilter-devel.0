From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v3] src: add _unset functions
Date: Fri, 7 Jun 2013 14:15:58 +0200
Message-ID: <20130607121558.GA6736@localhost>
References: <20130607105104.17347.95207.stgit@nfdev.cica.es>
 <20130607120631.GA6657@localhost>
 <CAOkSjBgogTrGwto9dcwBDGOWhZ00fH7_8w-ycON99tniCLK7fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42331 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab3FGMQD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:16:03 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgogTrGwto9dcwBDGOWhZ00fH7_8w-ycON99tniCLK7fw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 07, 2013 at 02:13:01PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/6/7 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Fri, Jun 07, 2013 at 12:52:17PM +0200, Arturo Borrero wrote:
> >> These functions unset the flag for the given attribute in each object and free data in some cases.
> >
> > Applied with minor changes, thanks Arturo.
> >
> > See below.
> >
> >> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> >> ---
> >> v2: improved unset operation and freed data pointer set to NULL
> >> v3: set to null c->table
> >>
> >>  include/libnftables/chain.h |    1 +
> >>  include/libnftables/rule.h  |    1 +
> >>  include/libnftables/set.h   |    2 ++
> >>  include/libnftables/table.h |    1 +
> >>  src/chain.c                 |   26 ++++++++++++++++++++++++++
> >>  src/libnftables.map         |    5 +++++
> >>  src/rule.c                  |   23 +++++++++++++++++++++++
> >>  src/set.c                   |   23 +++++++++++++++++++++++
> >>  src/set_elem.c              |   13 +++++++++++++
> >>  src/table.c                 |   15 ++++++++++++++-
> >>  10 files changed, 109 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
> >> index b12474f..f06f743 100644
> >> --- a/include/libnftables/chain.h
> >> +++ b/include/libnftables/chain.h
> >> @@ -26,6 +26,7 @@ enum {
> >>       NFT_CHAIN_ATTR_TYPE,
> >>  };
> >>
> >> +void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
> >>  void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const void *data);
> >>  void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uint32_t data);
> >>  void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int32_t data);
> >> diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
> >> index 9c4ab0d..9989f19 100644
> >> --- a/include/libnftables/rule.h
> >> +++ b/include/libnftables/rule.h
> >> @@ -23,6 +23,7 @@ enum {
> >>       NFT_RULE_ATTR_COMPAT_FLAGS,
> >>  };
> >>
> >> +void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
> >>  void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data);
> >>  void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val);
> >>  void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val);
> >> diff --git a/include/libnftables/set.h b/include/libnftables/set.h
> >> index 53c2947..211c065 100644
> >> --- a/include/libnftables/set.h
> >> +++ b/include/libnftables/set.h
> >> @@ -16,6 +16,7 @@ struct nft_set;
> >>  struct nft_set *nft_set_alloc(void);
> >>  void nft_set_free(struct nft_set *s);
> >>
> >> +void nft_set_attr_unset(struct nft_set *s, uint16_t attr);
> >>  void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data);
> >>  void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val);
> >>  void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str);
> >> @@ -61,6 +62,7 @@ void nft_set_elem_free(struct nft_set_elem *s);
> >>
> >>  void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem);
> >>
> >> +void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr);
> >>  void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, const void *data, size_t data_len);
> >>  void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t val);
> >>  void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str);
> >> diff --git a/include/libnftables/table.h b/include/libnftables/table.h
> >> index 658230c..09cd204 100644
> >> --- a/include/libnftables/table.h
> >> +++ b/include/libnftables/table.h
> >> @@ -18,6 +18,7 @@ enum {
> >>       NFT_TABLE_ATTR_FLAGS,
> >>  };
> >>
> >> +void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
> >>  void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data);
> >>  const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
> >>
> >> diff --git a/src/chain.c b/src/chain.c
> >> index 093e3ea..2a1a7ce 100644
> >> --- a/src/chain.c
> >> +++ b/src/chain.c
> >> @@ -59,6 +59,32 @@ void nft_chain_free(struct nft_chain *c)
> >>  }
> >>  EXPORT_SYMBOL(nft_chain_free);
> >>
> >> +void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
> >> +{
> >> +     switch (attr) {
> >> +     case NFT_CHAIN_ATTR_TABLE:
> >> +             if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE))
> >> +                     if (c->table) {
> >> +                             free(c->table);
> >> +                             c->table = NULL;
> >> +                     }
> >> +             break;
> >> +     case NFT_CHAIN_ATTR_USE:
> >> +             /* cannot be unset?, ignore it */
> >> +             return;
> >> +     case NFT_CHAIN_ATTR_TYPE:
> >> +             if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
> >> +                     if (c->type) {
> >> +                             free(c->type);
> >> +                             c->type = NULL;
> >> +                     }
> >> +             break;
> >
> >         default:
> >                 return;
> >
> > Added this just to skip for unknown attributes. It should not harm
> > though the current code, but just to ensure we don't spend cycles on
> > no operations.
> >
> 
> mmmmm...
> I think that if the attr is not selected in the switch, you will never reach:
> c->flags &= ~(1 << attr);
> 
> Or am I wrong?

Ouch, it was intentional indeed. I'll fix it.
