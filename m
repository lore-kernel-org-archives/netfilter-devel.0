Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC307C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82D064E2F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhBQPNI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 10:13:08 -0500
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:40370 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233790AbhBQPKF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 10:10:05 -0500
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 11HF514p039168;
        Wed, 17 Feb 2021 07:09:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=20180706;
 bh=3bKjo4L8t5umB9JTV5VPigJKejYRLknLTwxFKRDs8Lo=;
 b=V54KV8fwQRMeiSFkbuUMYa/B51R5uQUFRfhcQ0js75zOPmR2Zp/oqESzvExZiAV6GPJ+
 PpIVTqYXQig9ACt+L4GSzX8ql3PrOLeY2Wl8PxS0jWz5v0N6sTRjs0T7YNivtI3JGyL4
 6tVIYbZUf+MHxDf/hlDU1ZVRlrjfLLjc/vapQIgeVAFw6sSVVPdMEIjv9zGzV0J9SHOi
 kk5w7rJZWyzkbvOQCbOa0sJjymn1ab+3j2zaUC4lvicB2ZFlTD28N6DGaMh5OK0/po/q
 W7b+UhZUd+YYI7qnB01/jaCL6Awgzlr3hSeIeMGtIJy9i2BMCduZhcmfVSFQDbcg1Q0b UA== 
Received: from crk-mailsvcp-mta-lapp01.euro.apple.com (crk-mailsvcp-mta-lapp01.euro.apple.com [17.66.55.13])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 36pybtbryv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 17 Feb 2021 07:09:14 -0800
Received: from crk-mailsvcp-mmp-lapp01.euro.apple.com
 (crk-mailsvcp-mmp-lapp01.euro.apple.com [17.72.136.15])
 by crk-mailsvcp-mta-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QOO00HMSI3C4B00@crk-mailsvcp-mta-lapp01.euro.apple.com>; Wed,
 17 Feb 2021 15:09:12 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp01.euro.apple.com by
 crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QOO00N00I15L200@crk-mailsvcp-mmp-lapp01.euro.apple.com>; Wed,
 17 Feb 2021 15:09:12 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: b733bd983304443b63a993f2477c8539
X-Va-E-CD: cb0346f5cbfd522723d8a46174b91cc6
X-Va-R-CD: b1df0ddc24073e6ca5ac7487878a1cb6
X-Va-CD: 0
X-Va-ID: 9125a1cb-0a0b-49c5-b746-77e51e528a2c
X-V-A:  
X-V-T-CD: b733bd983304443b63a993f2477c8539
X-V-E-CD: cb0346f5cbfd522723d8a46174b91cc6
X-V-R-CD: b1df0ddc24073e6ca5ac7487878a1cb6
X-V-CD: 0
X-V-ID: 53b46677-5433-4063-b34c-2c9fb3dcd71c
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
Received: from [192.168.1.127] (unknown [17.232.99.29])
 by crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QOO002HVI3A9100@crk-mailsvcp-mmp-lapp01.euro.apple.com>;
 Wed, 17 Feb 2021 15:09:12 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.45.21011103
Date:   Wed, 17 Feb 2021 16:09:08 +0100
Subject: Re: [PATCH libnetfilter_queue] src: fix IPv6 header handling
From:   Etan Kissling <etan_kissling@apple.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-id: <DDC6C5C2-ADF1-4947-A5ED-A6EEC953F0F1@apple.com>
Thread-topic: [PATCH libnetfilter_queue] src: fix IPv6 header handling
References: <28947A39-55C4-4C68-8421-DEC950CF7963@apple.com>
 <20210209163042.GA6746@salvia>
In-reply-to: <20210209163042.GA6746@salvia>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 09.02.21, 17:33, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:

Thanks for looking into this.

> Note: nfq_ip6_set_transport_header() is very much similar to
> ipv6_skip_exthdr() in the Linux kernel, see net/ipv6/exthdrs_core.c

I submitted a revised version that uses similar logic as in the kernel
to exit the loop once extension headers are fully processed.

> >  		uint32_t hdrlen;
> >  
> >  		/* No more extensions, we're done. */
> > -		if (nexthdr == IPPROTO_NONE) {
> > +		if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP || nexthdr == IPPROTO_ESP ||
> > +		        nexthdr == IPPROTO_ICMPV6 || nexthdr == IPPROTO_NONE) {
> >  			cur = NULL;
> >  			break;
> >  		}
> > @@ -107,7 +108,7 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
> >  		} else if (nexthdr == IPPROTO_AH)
> >  			hdrlen = (ip6_ext->ip6e_len + 2) << 2;
> >  		else
> > -			hdrlen = ip6_ext->ip6e_len;
> > +			hdrlen = (ip6_ext->ip6e_len + 1) << 3;
>
> This looks correct, IPv6 optlen is miscalculated.
>
> The chunk above to stop the iteration, so I think the chunk that fixes
> optlen is sufficient to fix the bug.

The optlen fix is not sufficient when a non-existent 'target' is given.
For example, if a UDP packet is passed with 'target' IPPROTO_TCP,
the loop will go on and attempt to interpret the UDP packet body
as another IP extension header. Instead, by exiting the loop also
when all extension headers are processed, the function will now return
0 in that case, as documented in the header file.

Thanks

Etan



