Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EA3C10F06
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 00:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B822E214D8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 00:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552351236;
	bh=UaqAl+6ZWKxQzf2s7uTDX9ob1fDafeg9DL5Hv5DokZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k/eLtjdGMt44LGjoU6IJduwfoJEoCcsYSZfdk5elCs5wepxNuZM5vTJv/GJXguTl0
	 Z0X9r7uASeICX4GnIEgnKNx91tyjziSqLrv8a4/I/9LkFJ+V0EK0EKgCwC/uMJvpBh
	 IpIl1D01KOh+BAS3rXw7JuQ3lNI/6SjBs08YKLy8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfCLAkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 20:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfCLAkf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 20:40:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0CC20657;
        Tue, 12 Mar 2019 00:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552351235;
        bh=UaqAl+6ZWKxQzf2s7uTDX9ob1fDafeg9DL5Hv5DokZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7+EUrdjbYnDAQi9u+T01At3NbwtjexHQr8h+tBQVWgaS1Acr/8945+UrO2U+V2ce
         jQpWDXH1acEeHJ5xMPL0qf+H40QFvHxVC1LdqCf9A6jFr8hMaQk2F+GK/uhnpBEXTa
         a8Kne/vRDYyazYqEuVW/PR63qjzG3keFTlj3aCF8=
Date:   Mon, 11 Mar 2019 20:40:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     gregkh@linuxfoundation.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        netfilter-devel@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 2/2] netfilter: xt_TEE: add missing code to get
 interface index in checkentry.
Message-ID: <20190312004033.GM158926@sasha-vm>
References: <1552088294-18087-1-git-send-email-subashab@codeaurora.org>
 <1552088294-18087-2-git-send-email-subashab@codeaurora.org>
 <20190311123145.ixyboiw3szsymaa4@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190311123145.ixyboiw3szsymaa4@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 01:31:45PM +0100, Pablo Neira Ayuso wrote:
>Hi Greg,
>
>Cc'ing stable@vger.kernel.org.
>
>Subash (he's on Cc) needs these two fixes for 4.19:
>
>f24d2d4f9586985509320f90308723d3d0c4e47f
>netfilter: xt_TEE: fix wrong interface selection
>
>18c0ab87364ac5128a152055fdcb1d27e01caf01
>netfilter: xt_TEE: add missing code to get interface index in checkentry.
>
>Subash forgot to Cc stable@vger.kernel.org in his two patches, sorry
>about that.

Queued for 4.19, thank you.

--
Thanks,
Sasha
