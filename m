Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA94C43334
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jun 2022 08:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344098AbiFJI5R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbiFJI5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jun 2022 04:57:16 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Jun 2022 01:57:11 PDT
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3::9a49:2248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2757F24592
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2022 01:57:11 -0700 (PDT)
Received: from [165.16.203.51] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nza3o-0007Od-74; Fri, 10 Jun 2022 10:32:04 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nza3m-0003fl-CQ; Fri, 10 Jun 2022 10:32:02 +0200
Message-ID: <05d3ee34-8ff1-4bb3-b027-9fcc1ebb3526@uls.co.za>
Date:   Fri, 10 Jun 2022 10:32:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH nf] netfilter: nf_conntrack_tcp: re-init for syn packets
 only
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com, Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20220425094711.6255-1-fw@strlen.de> <YmlJzj82mBl77rCR@salvia>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <YmlJzj82mBl77rCR@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thank you all.  Got entangled in other stuff again, just wanted to say I
appreciate the effort that went into this.

Kind Regards,
Jaco

On 2022/04/27 15:49, Pablo Neira Ayuso wrote:
> On Mon, Apr 25, 2022 at 11:47:11AM +0200, Florian Westphal wrote:
>> Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
>> pinpointed to nf_conntrack tcp_in_window() bug.
>>
>> tcp trace shows following sequence:
>>
>> I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
>> R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
>> R > I Flags [P.], seq 1:89, ack 1, [..]
>>
>> Note 3rd ACK is from responder to initiator so following branch is taken:
>>     } else if (((state->state == TCP_CONNTRACK_SYN_SENT
>>                && dir == IP_CT_DIR_ORIGINAL)
>>                || (state->state == TCP_CONNTRACK_SYN_RECV
>>                && dir == IP_CT_DIR_REPLY))
>>                && after(end, sender->td_end)) {
>>
>> ... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
>> This causes the scaling factor to be reset to 0: window scale option
>> is only present in syn(ack) packets.  This in turn makes nf_conntrack
>> mark valid packets as out-of-window.
>>
>> This was always broken, it exists even in original commit where
>> window tracking was added to ip_conntrack (nf_conntrack predecessor)
>> in 2.6.9-rc1 kernel.
>>
>> Restrict to 'tcph->syn', just like the 3rd condtional added in
>> commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").
>>
>> Upon closer look, those conditionals/branches can be merged:
>>
>> Because earlier checks prevent syn-ack from showing up in
>> original direction, the 'dir' checks in the conditional quoted above are
>> redundant, remove them. Return early for pure syn retransmitted in reply
>> direction (simultaneous open).
> Applied, thanks
