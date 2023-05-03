Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65F8C77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 20:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjECUbD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 16:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjECUbC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 16:31:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 554097ABA
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 13:31:01 -0700 (PDT)
Date:   Wed, 3 May 2023 22:30:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <ZFLEgghj7qaIM4Sk@calendula>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, May 03, 2023 at 03:55:33PM +0300, Boris Sukholitko wrote:
[...]
> Now lets try to add flow offload:
> 
> table inet filter {
>         flowtable f1 {
>                 hook ingress priority filter
>                 devices = { veth0, veth1 }
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip dscp set cs3
>                 ip protocol { tcp, udp, gre } flow add 
>                 ct state established,related accept
>         }
> }

From user perspective, I think the way to go would be to allow users
to define a ruleset like this:

table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain ingress {
                type filter hook ingress device veth0 priority filter; policy accept; flags offload;
                ip dscp set cs3
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp, gre } flow add @f1
                ct state established,related accept
        }
}

This ruleset defines a policy at ingress, the offload flag tells that
this is offloaded to hardware for veth0, ie. all rule in the 'ingress'
chain will be placed in hardware in the ingress path. The IP DSCP
field is set on at the ingress (offload) hook, therefore, the host
(software) in tcpdump will see already mangled packets with IP DSCP
field set to cs3.

To achieve this, please have a look at net/netfilter/nf_tables_offload.c
for the ruleset offload infrastructure. This is called whenever the
chain comes with the offload flag set on.

struct nft_expr_ops provides an .offload and .offload_action callbacks
which you can use to populate the existing hardware offload API as
defined by include/net/flow_offload.h.

You will also have to extend the offload parser to translate the
nftables bytecode to the (hardware) flow_offload API, similar to what
nft_payload does to infer the header field you want to mangle (the
flow_offload hardware API uses the flow_dissector structure).

It is going to be a bit of work but I think this is feasible.

Thanks.
