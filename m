Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B57C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C161022DA8
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbfHTLuO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:50:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34228 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729741AbfHTLuN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 07:50:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i02eS-0004Hs-46; Tue, 20 Aug 2019 13:50:12 +0200
Date:   Tue, 20 Aug 2019 13:50:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2] netfilter: nfnetlink_log:add support for VLAN
 information
Message-ID: <20190820115012.GO2588@breakpoint.cc>
References: <20190820112617.18095-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820112617.18095-1-michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michael Braun <michael-dev@fami-braun.de> wrote:
> Currently, there is no vlan information (e.g. when used with a vlan aware
> bridge) passed to userspache, HWHEADER will contain an 08 00 (ip) suffix
> even for tagged ip packets.
> 
> Therefore, add an extra netlink attribute that passes the vlan information
> to userspace similarly to 15824ab29f for nfqueue.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> 
> --
> v2: mirror nfqueue behaviour

Thanks, looks good with one minor detail, see below.

>  /* This is an inline function, we don't really care about a long
>   * list of arguments */
>  static inline int
> @@ -580,6 +614,12 @@ __build_packet_message(struct nfnl_log_net *log,
>  				 NFULA_CT, NFULA_CT_INFO) < 0)
>  		goto nla_put_failure;

In nfulnl_log_packet(), you will need to add to "size" calculation, i.e.

+= nla_total_size(0)  /* nested */
+= nla_total_size(sizef(u16)) /* id */
+= nla_total_size(sizef(u16)) /* tag */

Furthermore (Unrelated to your patch), I think that the end of
__build_packet_message() (error handling) lacks a call to
nlmsg_cancel().

The printk could be removed and replaced by a WARN_ON_ONCE, it should
never be hit.
