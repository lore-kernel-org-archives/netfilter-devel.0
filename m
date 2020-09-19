Return-Path: <SRS0=GOfq=C4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F19C43463
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Sep 2020 15:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212CA2098B
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Sep 2020 15:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgISP64 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Sep 2020 11:58:56 -0400
Received: from correo.us.es ([193.147.175.20]:35732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgISP64 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Sep 2020 11:58:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1A431EF42D
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2020 17:52:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B315DA73F
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2020 17:52:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8318DA72F; Sat, 19 Sep 2020 17:52:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B63F1DA704;
        Sat, 19 Sep 2020 17:52:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 19 Sep 2020 17:52:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8346A41E4800;
        Sat, 19 Sep 2020 17:52:06 +0200 (CEST)
Date:   Sat, 19 Sep 2020 17:52:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20200919155206.GB28865@salvia>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <CAF90-Wiof1aut-KoA=uA-T=UGmUpQvZx_ckwY7KnBbYB8Y3+PA@mail.gmail.com>
 <b0989f93-e708-4a68-1622-ab3de629be77@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0989f93-e708-4a68-1622-ab3de629be77@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Daniel,

Long time no see, unfortunately this complicated situation is keeping
us away from personal reach, that's unfortunate. Now, looking into
this topic...

On Fri, Sep 18, 2020 at 10:31:09PM +0200, Daniel Borkmann wrote:
> [...] That is if there is an opt-in to such data path being used, then it also
> needs to continue to work, which gets me back to the earlier mentioned example
> with the interaction on the egress side with that hook that it needs to
> /interoperate/ with tc to avoid breakage of existing use cases in the wild.
> Reuse of skb flag could be one option to move forward, or as mentioned in
> earlier mails overall rework of ingress/egress side to be a more flexible
> pipeline (think of cont/ok actions as with tc filters or stackable LSMs to
> process & delegate).

The netfilter ingress hook was introduced many years after the tc
ingress "qdisc" (in the 4.2 kernel series), and I have absolutely no
records of one single complain from users in the netdev and netfilter
mailing lists regarding this being an issue / breaking anything. The
ingress hook needs to be *explicitly* registered by the user, so an
explicit user action to register the hook is required to register this
hook. As for this egress hook, it will be disabled by default too, since
egress chains are only registered on demand.

Assuming that preventing Netfilter to operate will *not* break things
makes no sense. It's the user that make sure that policies are
consistent across the datapath. I don't think there is any mechanism
that ensures that user policy fully makes sense.

Note that:

- The user can easily inspect if someone registered an egress hook.
- Your software can just report a warning to your user if there is an
  interaction with other subsystems makes no sense, it's just a bit of
  Netlink code from userspace if you don't want to wait for the user to
  notice.

You mentioned there is a real issue at this moment since AF_PACKET might
bypass dev_queue_xmit(), I think we can just ask Lukas to extend his
patch to include a hook there, so you can also follow up to fix this
issue for you too.

Thank you Daniel, stay safe.
