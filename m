From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH] libmnl: security context retrieval in nf-queue example
Date: Tue, 16 Jun 2015 14:58:50 +0200
Message-ID: <55801D8A.9050701@samsung.com>
References: <5565A4D2.70701@samsung.com> <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia> <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc> <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc> <557AB559.1000001@samsung.com>
 <20150612130240.GA29551@salvia> <558015A9.8060703@samsung.com>
 <20150616123706.GA32486@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14399 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbbFPM6y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 08:58:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ100K58G236880@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 16 Jun 2015 13:58:51 +0100 (BST)
In-reply-to: <20150616123706.GA32486@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems that there is nothing i can really add to there except maybe:
diff --git a/src/nlmsg.c b/src/nlmsg.c
index aebdd5e..cabd8be 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -137,6 +137,7 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
        case NFQA_IFINDEX_PHYSOUTDEV:
        case NFQA_CAP_LEN:
        case NFQA_SKB_INFO:
+       case NFQA_SECCTX:
        case NFQA_UID:
        case NFQA_GID:
                if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)

but that's a one line, will this be sufficient ? if so i'll merge this with the previous libnetfilter_queue patch
and send it as one.

On 06/16/2015 02:37 PM, Pablo Neira Ayuso wrote:
> On Tue, Jun 16, 2015 at 02:25:13PM +0200, Roman Kubiak wrote:
>> This patch is an addition to "[PATCH v3] nfnetlink_queue: add security context information"
>> It adds and example to libmnl that illustrates how to fetch security context.
>> A corresponding patch was sent for libnetfilter_queue already.
>>
>> -- cut here
>>
>> This patch modifies the example program for nf-queue
>> to demonstrate how to retriece security context information
>> for queued packages. This can also be easily extended to
>> retrieve other information supported by this subsystem.
> 
> This extension for the libmnl example is fine.
> 
> However, when we asked for changes, we actually mean that you enhance:
> 
>         libnetfilter_queue/src/nlmsg.c
> 
> to support this. Thanks.
> 
> 

-- 
--------------
 Roman Kubiak
--------------
