Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46278C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 08:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F137A217F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 08:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ap1KK/kd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCNIWF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:22:05 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37487 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfCNIWF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 04:22:05 -0400
Received: by mail-yw1-f65.google.com with SMTP id w66so3726065ywd.4
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 01:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rcUJigB0uv3BUskjW89qgdIMbAB7D+7CC+CtKqJjTg=;
        b=Ap1KK/kd9d6BnIBTL1ItPfyLMoFwzMxI9cZDIGGyW+DUPfgJTDgtl4Cp7Qxftop0xw
         hFudknScUi//UXqxvsbPFrK+Vn5T/BIpjk8OCiedVo0PAptcADv8QtrVRna4IPC9cVF1
         +gDmLIl0G8h8ak4gwDNdzGtNfIE0Mj0QLm+GfbdLz+7W7SY480h7me+Jci/iAtMnlBl0
         TqRMyjeF67wV4HeW9/wofUyHvdcF4U5fIPkCL6AnbziLloqPrt4hB8Yg+uFd9NMlZ7et
         zAk5iD53W1ibpRETeT50YfOWuRyK+r/Z9R401xY3D8+9PMFubrIosUvM1IxuIDnzKWf8
         iCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rcUJigB0uv3BUskjW89qgdIMbAB7D+7CC+CtKqJjTg=;
        b=mwdzl/ajAN0aGURq/FRCXtrVfrM6urpn1D+cpsa6lj8JM3gq631XWfYf1ef8YcGLWr
         jG2lWZ13WQEFdG8I2qUQ/jtEujK0aSZY3uGFKPyK+QNnkhCKGDwCs1z39fQMELebNnn1
         CibpdQv0Rm9RoIxE0fNbgPv314DxudWPfXqFNclmIwRT/1VK7gwAE3fdsdxD9E4SEiVg
         kkMoSidY8GvDYJW6Yj/zIosnyS+b6o8Jg7wxUx3W05pe1HGKCVOecSaCbWRiw1Em/c4H
         4keQLoWgZsPgxrZ6jMSx5lgC+OiHrQX8ttBp66zxVmqaFcClYEhKcpQnsFvS4faFfxIz
         gxyg==
X-Gm-Message-State: APjAAAUGk7pnXPQzpzZaAcs6edgXbH+mFoS4eOJUxyHEN4L9Mjs7KWaB
        h2ggptV9guzEHxA2TADGDqSb4nrJoEqg3/Kp/iw=
X-Google-Smtp-Source: APXvYqyLGxwDZCDqlAb2VzGMES6c+1Q76kbfNfyZfA1SdVp6PFUD58KK5suoo2zB9PxF/2NtpzgFdTw8EPni1Ha2B6U=
X-Received: by 2002:a81:9908:: with SMTP id q8mr37848267ywg.334.1552551724404;
 Thu, 14 Mar 2019 01:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <1552534124-31407-1-git-send-email-katrina.xiaorz@gmail.com>
In-Reply-To: <1552534124-31407-1-git-send-email-katrina.xiaorz@gmail.com>
From:   =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Date:   Thu, 14 Mar 2019 09:21:53 +0100
Message-ID: <CAF1oqRDDE8wxTLDW+uu1gD4uei2z=MKMRx7cTnqXxJO4B-0DBQ@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_conntrack_sip: fix rtcp expectation clash
To:     xiao ruizhu <katrina.xiaorz@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 14, 2019 at 4:27 AM xiao ruizhu <katrina.xiaorz@gmail.com> wrote:
>
> An unexpected RTCP expectation clash happens in the following scenario.
>
>            |      INVITE SDP (g711A g739 telephone-event)      |
>       5060 |<--------------------------------------------------|5060
>            |                 100 Trying                        |
>       5060 |-------------------------------------------------->|5060
>   S        |  183 Session Progress SDP (g711A telephone-event) |
>       5060 |-------------------------------------------------->|5060
>   E        |                    PRACK                          |      C
>      50601 |<--------------------------------------------------|5060
>   R        |                  200 OK (PRACK)                   |      P
>      50601 |-------------------------------------------------->|5060
>   V        |                  200 OK (INVITE)                  |      E
>       5060 |-------------------------------------------------->|5060
>   E        |                      ACK                          |
>      50601 |<--------------------------------------------------|5060
>   R        |                                                   |
>            |<------------------ RTP stream ------------------->|
>            |                                                   |
>            |                 INVITE SDP (t38)                  |
>      50601 |-------------------------------------------------->|5060
>
> With a certain configuration in the CPE, SIP messages "183 with SDP" and
> "re-INVITE with SDP t38" in the scenario will trigger the ALG to create
> expectations for RTP and RTCP.
>
> It is okay to create RTP&RTCP expectations for "183", whose master
> connection source port is 5060, and destination port is 5060.
>
> In this "183" message, port in Contact header changes to 50601 (from the
> original 5060). So the following requests e.g. PRACK are sent to port
> 50601. It has a different master connection (let call 2nd master
> connection) from the original INVITE (let call 1st master connection) due
> to the port difference.
>
> When "re-INVITE with SDP t38" arrives to create RTP&RTCP expectations,
> current ALG implementation will firstly check whether there is a RTP
> expectation with the same tuples already exists for a different master
> connection. If yes, it will skip RTP&RTCP expects creation; otherwise it
> will create a new RTP&RTCP expectation pairs.
>
> In the scenario above, there is RTP stream but no RTCP stream for the 1st
> master connection, so the RTP expectation created upon "183" is cleared,
> and RTCP expectation created for the 1st master connection retains.
>
> Basing on current ALG implementation, it only checks RTP expectation
> existence but not for RTCP. So when "re-INVITE with SDP t38" arrives, it
> will continue to create a new RTP&RTCP expectation pairs for the 2nd master
> connection, which will result in a detection of expectation clash for RTCP
> (same tuples and different master), and then a failure in processing of
> that re-INVITE.
>
> The fixing here is to check both RTP and RTCP expectation existence before
> creation. When there is an old expectation with same tuples for a different
> master, release the old expectation. Then a new one will be created for the
> current master.
>
> Signed-off-by: xiao ruizhu <katrina.xiaorz@gmail.com>
> ---
> Changes in v2:
> - add a comment on release_conflicting_expect functionality
> - move local variable errp to the beginning of the block
> v1:
> - original patch
> ---
>  net/netfilter/nf_conntrack_sip.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index f067c6b..4398a53 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -799,6 +799,23 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
>         return 1;
>  }
>
> +/* Remove conflicting expect created by sip helper for another master
> + * conntrack, most likely related to this master.
> + */
> +static void release_conflicting_expect(const struct nf_conn *ct,
> +                                      const struct nf_conntrack_expect *expect,
> +                                      const enum sip_expectation_classes class)
> +{
> +       struct nf_conntrack_expect *exp;
> +       struct net *net = nf_ct_net(ct);
> +
> +       exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);
> +       if (exp && exp->master != ct &&
> +           nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
> +           exp->class == class)
> +               nf_ct_unexpect_related(exp);
> +}
> +
>  static int refresh_signalling_expectation(struct nf_conn *ct,
>                                           union nf_inet_addr *addr,
>                                           u8 proto, __be16 port,
> @@ -980,11 +997,16 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
>                                        datalen, rtp_exp, rtcp_exp,
>                                        mediaoff, medialen, daddr);
>         else {
> +               int errp;
> +
> +               release_conflicting_expect(ct, rtp_exp, class);
> +               release_conflicting_expect(ct, rtcp_exp, class);
> +
>                 /* -EALREADY handling works around end-points that send
>                  * SDP messages with identical port but different media type,
>                  * we pretend expectation was set up.
>                  */
> -               int errp = nf_ct_expect_related(rtp_exp);
> +               errp = nf_ct_expect_related(rtp_exp);
>
>                 if (errp == 0 || errp == -EALREADY) {
>                         int errcp = nf_ct_expect_related(rtcp_exp);
> --
> 1.9.1
>

Acked-by: Alin Nastac <alin.nastac@gmail.com>
