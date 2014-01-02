From: Eric Leblond <eric@regit.org>
Subject: Re: [libnftables PATCH] expr: add ct_set expression
Date: Thu, 02 Jan 2014 11:15:24 +0100
Message-ID: <1388657724.29019.5.camel@ice-age2.regit.org>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
	 <1388654079-31459-1-git-send-email-eric@regit.org>
	 <CAOkSjBg5C6eCQ-AA-E5Wr9wExo8hZsEk3Bz2G5BPpqAVHBtoGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55240 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaABKP2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:15:28 -0500
In-Reply-To: <CAOkSjBg5C6eCQ-AA-E5Wr9wExo8hZsEk3Bz2G5BPpqAVHBtoGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, 2014-01-02 at 10:52 +0100, Arturo Borrero Gonzalez wrote:
> On 2 January 2014 10:14, Eric Leblond <eric@regit.org> wrote:
> > This patch adds support for 'ct_set' expression which is a port
> > of iptables CT target.
> >
> > Signed-off-by: Eric Leblond <eric@regit.org>
> 
> Hi Eric, this patch looks good. Some comments below:
> 
> > +static const void *
> > +nft_rule_expr_ct_set_get(const struct nft_rule_expr *e, uint16_t type,
> > +                     uint32_t *data_len)
> > +{
> > +       struct nft_expr_ct_set *ct_set = nft_expr_data(e);
> > +
> > +       switch(type) {
> > +       case NFT_EXPR_CT_SET_FLAGS:
> > +               *data_len = sizeof(ct_set->flags);
> > +               return &ct_set->flags;
> > +       case NFT_EXPR_CT_SET_PROTO:
> > +               *data_len = sizeof(ct_set->proto);
> > +               return &ct_set->proto;
> > +       case NFT_EXPR_CT_SET_ZONEID:
> > +               *data_len = sizeof(ct_set->zoneid);
> > +               return &ct_set->zoneid;
> > +       case NFT_EXPR_CT_SET_CTEVENTS:
> > +               *data_len = sizeof(ct_set->ct_events);
> > +               return &ct_set->ct_events;
> > +       case NFT_EXPR_CT_SET_EXPEVENTS:
> > +               *data_len = sizeof(ct_set->exp_events);
> > +               return &ct_set->exp_events;
> > +       case NFT_EXPR_CT_SET_HELPER:
> > +               *data_len = strlen(ct_set->helper)+1;
> > +               return ct_set->helper;
> > +       case NFT_EXPR_CT_SET_TIMEOUT:
> > +               *data_len = strlen(ct_set->timeout)+1;
> 
> Why +1 here?
> Others expressions, like 'log' or 'lookup' simply sets data_len with strlen().

'log' is is using a char * and in length computation it is using +1 to
get the terminal 0 at the end of the string:

		*data_len = strlen(log->prefix)+1;
		return log->prefix;

and 'lookup' is using a direct access. I think it is because we have:

	char			set_name[IFNAMSIZ];

and in setter function:

		memcpy(lookup->set_name, data, IFNAMSIZ);
		lookup->set_name[IFNAMSIZ-1] = '\0';

So doing the following is ok in the getter function. We are sure we will
have a terminal 0 and we know the size of data:
	case NFT_EXPR_LOOKUP_SET:
		return lookup->set_name;

> I guess either this or the others aren't good, don't you?

No ;)

> 
> > +
> > +static int nft_rule_expr_ct_set_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
> > +{
> > +#ifdef XML_PARSING
> > +       struct nft_expr_ct_set *ct_set = nft_expr_data(e);
> > +       const char *uvalstr;
> > +
> > +       if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
> > +                              &ct_set->flags, NFT_TYPE_U16, NFT_XML_MAND) != 0)
> > +               return -1;
> 
> I see now that errno is not set anywhere in the error path of XML/JSON
> expression parsing code.
> 
> I will patch nft_mxml_expr_parse() and nft_jansson_expr_parse().

Good catch!

BR,
-- 
Eric Leblond <eric@regit.org>

