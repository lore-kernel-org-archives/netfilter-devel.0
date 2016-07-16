From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix unpaired nf_connlabels_get/put
 call
Date: Sat, 16 Jul 2016 11:18:01 +0200
Message-ID: <20160716091801.GB6123@breakpoint.cc>
References: <1468650441-17407-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49023 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbcGPJSX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 05:18:23 -0400
Content-Disposition: inline
In-Reply-To: <1468650441-17407-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We only get nf_connlabels if the user add ct label set expr successfully,
> but we will also put nf_connlabels if the user delete ct lable get expr.
> This is mismathced, and will cause ct label expr cannot work properly.
> 
> Also, if we init something fail, we should put nf_connlabels back.
> Otherwise, we may waste to alloc the memory that will never be used.

Acked-by: Florian Westphal <fw@strlen.de>

Unrelated to your patch:

I think its time to change conntrack labels to a pure 128 bit field:

#define NF_CT_LABELS_MAX_SIZE ((XT_CONNLABEL_MAXBIT + 1) / BITS_PER_BYTE)

struct nf_conn_labels {
	unsigned long bits[NF_CT_LABELS_MAX_SIZE];
};

static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
{
#ifdef CONFIG_NF_CONNTRACK_LABELS
        struct nf_conn_labels *cl_ext;
        struct net *net = nf_ct_net(ct);

        if (net->ct.labels_used == 0)
                return NULL;

        cl_ext = nf_ct_ext_add_length(ct, NF_CT_EXT_LABELS,
                                      sizeof(struct nf_conn_labels), GFP_ATOMIC);
        if (cl_ext != NULL)
                cl_ext->words = words;

        return cl_ext;
#else
        return NULL;
#endif
}

Most arches are 64bit so once one label is active we already allocate 16 bytes
due to the padding hole in nf_conn_labels struct.

OVS always asks for 128bit so in that case we'd only allocate 16 instead of the
current 24 byte.
