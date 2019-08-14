Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F24C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E92020843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHNJRl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:17:41 -0400
Received: from correo.us.es ([193.147.175.20]:40790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfHNJRl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 05:17:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 259B2C40E5
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:17:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15C77DA704
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:17:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0B71FDA730; Wed, 14 Aug 2019 11:17:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FD2FDA704;
        Wed, 14 Aug 2019 11:17:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:17:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA40B4265A2F;
        Wed, 14 Aug 2019 11:17:36 +0200 (CEST)
Date:   Wed, 14 Aug 2019 11:17:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 5/9] netfilter: nft_tunnel: support
 NFT_TUNNEL_SRC/DST_IP match
Message-ID: <20190814091736.b5f44pvg46n5epxn@salvia>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
 <1564668086-16260-6-git-send-email-wenxu@ucloud.cn>
 <20190813181930.ljrisiq2iszcddlk@salvia>
 <ba98af8c-fcd3-50dd-770d-ddb85a887031@ucloud.cn>
 <20190814080037.w7xi2htgshg2adsd@salvia>
 <20190814081915.xnogz4ktan6siowo@salvia>
 <5690e59a-1e03-1463-a876-c592949ceb64@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5690e59a-1e03-1463-a876-c592949ceb64@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 14, 2019 at 04:28:43PM +0800, wenxu wrote:
> 
> On 8/14/2019 4:19 PM, Pablo Neira Ayuso wrote:
> > On Wed, Aug 14, 2019 at 10:00:37AM +0200, Pablo Neira Ayuso wrote:
> > [...]
> >>>>> @@ -86,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
> >>>>>  		len = sizeof(u8);
> >>>>>  		break;
> >>>>>  	case NFT_TUNNEL_ID:
> >>>>> +	case NFT_TUNNEL_SRC_IP:
> >>>>> +	case NFT_TUNNEL_DST_IP:
> >>>> Missing policy updates, ie. nft_tunnel_key_policy.
> >>> I don't understand why it need update nft_tunnel_key_policy
> >>> which is used for tunnel_obj action. This NFT_TUNNEL_SRC/DST_IP is used
> >>> for tunnel_expr
> >> It seems there is no policy object for _get_eval(), add it.
> > There is. It is actually nft_tunnel_policy.
> 
> nft_tunnel_policy contain a NFTA_TUNNEL_KEY
> 
> NFTA_TUNNEL_KEY support NFT_TUNNEL_ID, NFT_TUNNEL_SRC/DST_IP
> 
> I think the NFTA_TUNNEL_KEY  means a match key which can be tun_id, tun_src, tun_dst

Correct.
