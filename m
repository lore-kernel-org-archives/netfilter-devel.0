From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH] [PATCH] dynamic calculation of event message size for ctnetlink
Date: Wed, 18 Mar 2009 09:38:40 +0100
Message-ID: <20090318083840.GA9679@mail.eitzenberger.org>
References: <20090317094909.6434.27331.stgit@Decadence> <49BF91A8.2070900@trash.net> <20090317121446.GB3526@mail.eitzenberger.org> <49BF94A6.6080508@trash.net> <49C0266B.40204@netfilter.org> <49C07B87.90404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:50752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZCRIir (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:38:47 -0400
Content-Disposition: inline
In-Reply-To: <49C07B87.90404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 18, 2009 at 05:41:43AM +0100, Patrick McHardy wrote:

> >This calculation results in no message trim if most of those attributes
> >are present. However, assuming the worst case (no counters, no helper,
> >no mark, no master tuple, etc.), netlink_trim() may be called. My patch
> >calculates the exact size, so there's no trimming for any case.
> 
> The numbers imply that its still a net win. But its a valid point, if
> the common case will still result in reallocations, it might make sense
> to include the space for a few of those members optionally to make
> sure we don't cross the 50% waste threshold.

That's a good point.

For reference these are the attributes of TCP conntrack event, I have
marked the optional NLAs.  I don't know what the ratio is in bytes
though.

CTA_TUPLE_ORIG                          NLA_F_NESTED
    CTA_TUPLE_IP                        NLA_F_NESTED
        CTA_IP_V4_SRC
        CTA_IP_V4_DST
    CTA_TUPLE_PROTO                     NLA_F_NESTED
        CTA_PROTO_NUM
        CTA_PROTO_SRC_PORT
        CTA_PROTO_DST_PORT
CTA_TUPLE_REPLY                         NLA_F_NESTED
    CTA_TUPLE_IP                        NLA_F_NESTED
        /* ipv6_tuple_to_nl_attr() */
        CTA_IP_V4_SRC
        CTA_IP_V4_DST
    CTA_TUPLE_PROTO                     NLA_F_NESTED
        CTA_PROTO_NUM
        CTA_PROTO_SRC_PORT   
        CTA_PROTO_DST_PORT
CTA_ID
CTA_STATUS
CTA_COUNTERS_ORIG                       NLA_F_NESTED optional
    CTA_COUNTERS_PACKETS
    CTA_COUNTERS_BYTES
CTA_COUNTERS_REPLY                      NLA_F_NESTED optional
    CTA_COUNTERS_PACKETS
    CTA_COUNTERS_BYTES
CTA_TIMEOUT
CTA_PROTOINFO                           NLA_F_NESTED
    CTA_PROTOINFO_TCP                   NLA_F_NESTED
        CTA_PROTOINFO_TCP_STATE
        CTA_PROTOINFO_TCP_WSCALE_ORIGINAL
        CTA_PROTOINFO_TCP_WSCALE_REPLY
        CTA_PROTOINFO_TCP_FLAGS_ORIGINAL
        CTA_PROTOINFO_TCP_FLAGS_REPLY
CTA_HELP								optional
    CTA_HELP_NAME
CTA_SECMARK                             optional
CTA_TUPLE_MASTER                        NLA_F_NESTED optional
    CTA_TUPLE_IP                        NLA_F_NESTED
        CTA_IP_V4_SRC 
        CTA_IP_V4_DST
    CTA_TUPLE_PROTO                     NLA_F_NESTED
        CTA_PROTO_NUM
        CTA_PROTO_SRC_PORT
        CTA_PROTO_DST_PORT
CTA_NAT_SEQ_ADJ_ORIG                    NLA_F_NESTED optional
    CTA_NAT_SEQ_CORRECTION_POS
    CTA_NAT_SEQ_OFFSET_BEFORE
    CTA_NAT_SEQ_OFFSET_AFTER
CTA_NAT_SEQ_ADJ_REPLY                   NLA_F_NESTED optional
    CTA_NAT_SEQ_CORRECTION_POS
    CTA_NAT_SEQ_OFFSET_BEFORE
    CTA_NAT_SEQ_OFFSET_AFTER
CTA_MARK                  				optional
