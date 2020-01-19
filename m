Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F1BC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 17:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A5E20674
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 17:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgASRuL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 12:50:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:50722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgASRuL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 12:50:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92E9FAD19;
        Sun, 19 Jan 2020 17:50:09 +0000 (UTC)
Subject: Re: [PATCH nf] netfilter: conntrack: sctp: use distinct states for
 new SCTP connections
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200118121050.GA22909@incl>
 <20200118203900.4cbujiax7jcg73dk@salvia>
From:   Jiri Wiesner <jwiesner@suse.com>
Message-ID: <e53e196c-5300-982c-4c06-d20b31857b32@suse.com>
Date:   Sun, 19 Jan 2020 18:50:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200118203900.4cbujiax7jcg73dk@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 18/01/2020 21:39, Pablo Neira Ayuso wrote:
> On Sat, Jan 18, 2020 at 01:10:50PM +0100, Jiri Wiesner wrote:
>> The netlink notifications triggered by the INIT and INIT_ACK chunks
>> for a tracked SCTP association do not include protocol information
>> for the corresponding connection - SCTP state and verification tags
>> for the original and reply direction are missing. Since the connection
>> tracking implementation allows user space programs to receive
>> notifications about a connection and then create a new connection
>> based on the values received in a notification, it makes sense that
>> INIT and INIT_ACK notifications should contain the SCTP state
>> and verification tags available at the time when a notification
>> is sent. The missing verification tags cause a newly created
>> netfilter connection to fail to verify the tags of SCTP packets
>> when this connection has been created from the values previously
>> received in an INIT or INIT_ACK notification.
>>
>> A PROTOINFO event is cached in sctp_packet() when the state
>> of a connection changes. The CLOSED and COOKIE_WAIT state will
>> be used for connections that have seen an INIT and INIT_ACK chunk,
>> respectively. The distinct states will cause a connection state
>> change in sctp_packet().
> This problem shows through conntrack -E, correct?
>
> Thanks.
Yes, although "conntrack -E" does not display verification tags. These 
are the first 3 notifications of an association as printed by "conntrack 
-E" (output truncated after src=):
     [NEW] ipv4     2 sctp     132 3 src=
  [UPDATE] ipv4     2 sctp     132 3 src=
  [UPDATE] ipv4     2 sctp     132 3 COOKIE_ECHOED src=
As you see, there is no connection state printed in the first two 
notifications.

I used a custom tool which can print verification tags and formats its 
output similarly to "conntrack -E":
     [NEW] ipv4     2 sctp     132 3 0 0 src=
  [UPDATE] ipv4     2 sctp     132 3 0 0 src=
  [UPDATE] ipv4     2 sctp     132 3 COOKIE_ECHOED 50ced389 e967350e src=
The tags are printed as zero in the first two notifications, but that 
rather means the tags have not been received in the notification. The 
above test was done under Linux 5.5-rc4.
