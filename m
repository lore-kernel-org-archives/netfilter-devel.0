Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8B8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Feb 2022 16:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbiBQQz1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 11:55:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBQQz1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 11:55:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F362B3551;
        Thu, 17 Feb 2022 08:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 555D8B821AE;
        Thu, 17 Feb 2022 16:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72679C340E8;
        Thu, 17 Feb 2022 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645116910;
        bh=DKw7A7VZqiMKEV24XPr8gsA6RRZcD4t308cI8Q4UvaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBe+Iv+THaAw99Gz0yZjBVXP1cfxHgsBDQX4e3sL5a0VhRrGFkTcp2VHfusabaMX/
         RFGHSWV7JHwDRfwSowXbnPmYxlN/gkFQdqbJpkW1NiK80CaqyjxBQ9mOWz/3qrzyLu
         ClUSJ2yGaR9zbMk69Eex1PSgUewL8N69AOiqWk8gBMFfIr2Y4ngJzYtmY6btFhgi0v
         TG/VvYI+nF60bQjoo2EzxhBWHIxrKgpqPAjNHrbWaSg+6zLuU9hC/FajxZ6Y+1veaa
         lfLajqJD9HRtSSqWPHGjzT/9Rr9ZgENhtRasBQTW5qYgUuOqofw6/M+XJLoBG7ul5l
         eRxUfeYlEt0Rg==
Date:   Thu, 17 Feb 2022 08:55:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, <coreteam@netfilter.org>
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
Message-ID: <20220217085508.0788d154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217093424.23601-1-paulb@nvidia.com>
References: <20220217093424.23601-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 17 Feb 2022 11:34:24 +0200 Paul Blakey wrote:
> Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tupledx")

Fixes tag: Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tupledx")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
