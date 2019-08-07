Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD87C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 16:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20A1D22297
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 16:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfHGQgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 12:36:51 -0400
Received: from correo.us.es ([193.147.175.20]:43440 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387943AbfHGQgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 12:36:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 76BFFB5AA4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2019 18:36:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6561ADA7E1
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2019 18:36:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B0D8DA730; Wed,  7 Aug 2019 18:36:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 365B4DA72F;
        Wed,  7 Aug 2019 18:36:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Aug 2019 18:36:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BE3364265A2F;
        Wed,  7 Aug 2019 18:36:44 +0200 (CEST)
Date:   Wed, 7 Aug 2019 18:36:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dirk Morris <dmorris@metaloft.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <20190807163641.vrid7drwsyk2cer4@salvia>
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 06, 2019 at 05:57:50PM -0700, Dirk Morris wrote:
> On 8/6/19 5:34 PM, Florian Westphal wrote:
> 
> > 
> > This is unexpected, as the id function is only supposed to be called
> > once the conntrack has been confirmed, at which point all NAT side
> > effects are supposed to be done.
> > 
> > In which case(s) does that assumption not hold?
> > 
> 
> Yeah, I figured that might be the reasoning.
> 
> In my case either from a queue event or log event in userspace.
> Which is always pre-confirmation for the first packet of any connection until late.
> 
> psuedo-code:
> 
> nft add table inet foo
> nft add chain inet foo prerouting "{ type filter hook prerouting priority -123 ; }"
> nft add chain inet foo postrouting "{ type filter hook postrouting priority -123 ; }"
> nft add rule inet foo prerouting queue num 1234
> nft add rule inet foo postrouting queue num 1234
> 
> or
> 
> nft add table inet foo
> nft add chain inet foo prerouting "{ type filter hook prerouting priority -123 ; }"
> nft add chain inet foo postrouting "{ type filter hook postrouting priority -123 ; }"
> nft add rule inet foo prerouting log prefix "prerouting" group 0
> nft add rule inet foo postrouting log prefix "postrouting" group 0
> 
> and then in some userspace daemon something like:
> 
> ct_len = nfq_get_ct_info(nfad, &ct_data);
> nfct_payload_parse((void *)ct_data,ct_len,l3num,ct)
> id = nfct_get_attr_u32(ct,ATTR_ID);
> 
> or
> 
> *data = nfnl_get_pointer_to_data(nfa->nfa,NFULA_CT,char)
> nfct_payload_parse((void *)data,ct_len,l3num,ct )
> id = nfct_get_attr_u32(ct,ATTR_ID);
> 
> Its just a convenience to have it not change if possible (assuming the proposal
> maintains the same level of uniqueness - not 100% sure on that).
> 
> Listening to the conntrack events this does not happen, as you get the NEW event
> only after the ct is confirmed, but unfortunately you get the packet from queue
> and the log messages well before that.

ct->ext also might change while packet is in transit, since new
extension can be added too.

&ct->tuplehash was not good either for event retransmission, since
hnnode might change (when moving the object to the dying list), so
ct->tuplehash[x].tuple looks good to me.

@Florian: by mangling this patch not to use ct->ext, including Dirk's
update, conntrackd works again (remember that bug we discussed during
NFWS).

@@ -470,8 +470,8 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 
        a = (unsigned long)ct;
        b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
-       c = (unsigned long)ct->ext;
-       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL], sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL]),
+       c = (unsigned long)0;
+       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);

I think it's safe to turn this into:

        a = (unsigned long)ct;
        b = (unsigned long)ct->master;
        c = (unsigned long)nf_ct_net(ct));
        d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
