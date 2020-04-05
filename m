Return-Path: <SRS0=tJPO=5V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C518FC2BA16
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 03:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CA7E2078A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 03:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDED3L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Apr 2020 23:29:11 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:36816 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgDED3L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Apr 2020 23:29:11 -0400
Received: from [192.168.1.6] (unknown [101.93.37.154])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3EF45418D3
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2020 11:29:02 +0800 (CST)
Subject:  flowtable crash in nf_flow_table_indr_block_cb
References: <2d1dd983-bc7c-7e8d-965d-0ec7d9716c1a@ucloud.cn>
To:     netfilter-devel@vger.kernel.org
From:   wenxu <wenxu@ucloud.cn>
X-Forwarded-Message-Id: <2d1dd983-bc7c-7e8d-965d-0ec7d9716c1a@ucloud.cn>
Message-ID: <db9dfe4f-62e7-241b-46a0-d878c89696a8@ucloud.cn>
Date:   Sun, 5 Apr 2020 11:28:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2d1dd983-bc7c-7e8d-965d-0ec7d9716c1a@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVktVTktLS0tLSkxDQ0pIQkhPWVdZKF
        lBSUI3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDo6Mxw5SjgrSxRRAkMvHiFL
        Hj8wCklVSlVKTkNNS05MSE9JTkJKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVC
        SFVITFVKTk9ZV1kIAVlBSkNCQjcG
X-HM-Tid: 0a7148626d522086kuqy3ef45418d3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


Flowtable will crash in nf_flow_table_indr_block_cb when the nf_tables 
modules is not in.


# modprobe act_ct

The act_ct will auto load the flowtable modules.

# ip l a dev gre type gretap external.


nf_flow_table_indr_block_cb will crash for the uninit in net->nft.tables.

I thinkthe following patch is not good a solution indeely

http://patchwork.ozlabs.org/patch/1257422/


The flowtable can be used by both nf_tables and act_ct.

But the nf_flow_table_indr_block_cb in flow_indr_block_entry

only be used for nf_tables.  So move the flow_indr_add_block_cb

to the nf_tables modules is a better solution? such as nf_tables_offload.c

or a new nf_flow_table_indr_offload.c?

And the flowtable modules don't need to include the nf_tables.h



BR

wenxu






