Return-Path: <SRS0=tBTY=SM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02151C10F14
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Apr 2019 10:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C02BD20830
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Apr 2019 10:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7/2Qn6p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbfDJKru (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 06:47:50 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:38163 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730706AbfDJKrt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 06:47:49 -0400
Received: by mail-wm1-f54.google.com with SMTP id w15so2037872wmc.3;
        Wed, 10 Apr 2019 03:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IlOlvllLCb4mFv3NHy4iq6nwncGuxZrWcuLR/98ZkyM=;
        b=j7/2Qn6pkhSXM3IcQ+TQ+dX41h6pHiuntsMNSc3i+lqdbz0QX5PkHpSTe3aKLGCidk
         NtQmwoOA7c2AzkXihIOa0X0wVobi88gMytCaIeKz56doSMPfWrNkYzKifQ8UytbuX5Rj
         mwXM+vZGV3Ay8io2dGsByj90t/bA/sTa7xp7PcTNlBXyLQxFzThLHByyKQqHPr8Mu8Ar
         TkBRiKC9JOhS0o7ynM8vYkx0gGuglDUyaNDRBAnDH60yNTWX1mF/mnU1tUhc/0E+k/XI
         B67e+DP1W0fh5B+Eexf+JdjUJcMVM65m++Zl56YS4xzuSpQQTsldOl5jfn+LPp5H0SeI
         JgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IlOlvllLCb4mFv3NHy4iq6nwncGuxZrWcuLR/98ZkyM=;
        b=kEYaSMboJbe6ztKIIWXePIFNHQAcqIu3lCfZEqM5Pc78qEia1HnMooBZDJ/MSuAs5T
         eV7qr5o7doHLBhI8Y+cHF7TNOThAIDqQBNGhm9OTimQQZXTon229Y4BkM7Zwe3xtQXcn
         Vi9GpD6AzvasFNny9aclYKKlFOP9n+OpSslHgxydPXyhpx9GT8H8Wo7Xyi4mFnzyvmFi
         dCvAJ6ZyqvZAmY08eFv1sgMmSMkLuwPdooVHX2nX7+wusbAq0vmQc59r8901CE6yEtLn
         1UXg2FHa08VJkjadKhJxK5HQzSz3mV627PKLyB7Hf3D3/vexsHadKvZCazvpF6hyJI8K
         +Ebw==
X-Gm-Message-State: APjAAAV5bQPN2iK6SDt94NebH3v75SCRCtr0ZXlThY3vFgLekTua3PCh
        hcbnJxX6irfOH9r1rFRteZZMH+5S0kqvRueiBcMn4UAf
X-Google-Smtp-Source: APXvYqw0tlnY9HJQyuU1ngHs925ded9BJx1c462gJyRNXV+zATjqC6cg4vWpYqDSMq4YKMfIExk6orcU8M0zL4aznpc=
X-Received: by 2002:a1c:5f42:: with SMTP id t63mr2259655wmb.94.1554893267631;
 Wed, 10 Apr 2019 03:47:47 -0700 (PDT)
MIME-Version: 1.0
From:   Naruto Nguyen <narutonguyen2018@gmail.com>
Date:   Wed, 10 Apr 2019 17:47:35 +0700
Message-ID: <CANpxKHGdbN6UYTw=r=r9=usZ3taX05ARpnAQ_StF4Zikcpp5WA@mail.gmail.com>
Subject: ESTABLISHED tcp conntrack timeout
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello everyone,

When duplicating tcp conntrack from main name space to another network
namespace, I see that sometimes timeout value for an established tcp
connection in another network namespace has been changed from 432000
to 300 like below, even it is in ASSURED

03:05:53.773
tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:05:56.018
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:05:58.267
tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:00.511
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:02.767
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:05.024
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:07.318
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:09.578
tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:11.833
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:14.082
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:16.315
tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:25.314
tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:27.571
tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:29.815
tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
[ASSURED] mark=0 use=1
03:06:32.065

In nf_conntrack_proto_tcp.c, I see that 2 constants have 5 mins set

[TCP_CONNTRACK_RETRANS] = 5 MINS,
[TCP_CONNTRACK_UNACK] = 5 MINS,

and the code

if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
       timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
       timeout = timeouts[TCP_CONNTRACK_RETRANS];
else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
       IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
       timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
       timeout = timeouts[TCP_CONNTRACK_UNACK];
else
       timeout = timeouts[new_state];

but I am not sure this code cause the above issue. For the second
TCP_CONNTRACK_UNACK, it only happens for [UNREPLIED] instead of
[ASSURED]. Could you please let me know how the time out value can be
changed for an established tcp connection and how to prevent this
change?

Thanks,
Brs,
Naruto
