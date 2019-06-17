Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E23C31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 09:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB2F2064B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 09:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AK2Jwpw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfFQJmd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 05:42:33 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:44970 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfFQJmd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 05:42:33 -0400
Received: by mail-ed1-f52.google.com with SMTP id k8so15190679edr.11
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 02:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2GSfw2ATPbOF8HwJxA9NOavYnkUKl01/jpAVz1bAOTs=;
        b=AK2Jwpw89QS4o3sg4/U8B1dOWIdVZGuMPbRWQkNpu8JQbQ07UhBh72E4QB8NGVmXtU
         ciIzJTafkfIob0kTSRX1TSWqwWGQiMBsEw+Nu4uB+jnJgvB3sY/xbSpj3nKghcje+lZI
         89MPPNUeKcM5RIps9nAXCejvfCw1+o1UbS6d0mdw9mmycmxbOWWCMWxZ2t/6VyoMJZv5
         evB4v84vXva9I5D2g6cJJ/RXFGAfjb2E7wl4e4BbRXbdn7V/fQ3dlIowbWWNMytlmGfm
         uv1S7208Q4LL6B+o9cFq7n4nEBDFNj5StelN6lzVq71lcSjEJxD9zslfRNkrd4g8rDPk
         08jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2GSfw2ATPbOF8HwJxA9NOavYnkUKl01/jpAVz1bAOTs=;
        b=ebd+v5VB2jzb1syW9es3zkst5C7NpDEbW/BiTzcHld2aLLXff2KOGQu0N+WuyNFqQc
         fmYj3UQ7OR+2obz54VSRdG/jDkE1oJJDKIc8LPBjaLMSxm1E6AFjRwP+GXFXGNygMAMU
         2qaA8GcONNLDUXohFoyOIkifJyyfowngfaMpwHBy/HKYVJPcG82eneDEeFHc8tqCaxaU
         kOngp0/gdd7mAECz+GTeFU1VOJt94Ay+kl8Z/KC0HFnlm0W/ThGDRNLR5TFfZXdwm0eG
         iOHvq+pBJ0Qf9wajNBI0Avy0ijOJnCro+iigUqmIWqeyy9L3aDuIPNHtxqxZe0dFA+qk
         QSsQ==
X-Gm-Message-State: APjAAAUOpgDkRjVMND3fmZYQ17lslwe//Pv7jzUJ6vgI6Qs7icGU4rQ1
        58zN/yKv4LEm4+bDoVcl6lG9UbZauiEAowiGw/Nnm5yFcWc=
X-Google-Smtp-Source: APXvYqw/3OxDlpsLn/bnZHNBBZrzjVvI0SJC+OKGidz9dLoVPWbddoJvVNjr67TOHAYM66wcztoOJWVapkPX+siAWeY=
X-Received: by 2002:a17:906:4482:: with SMTP id y2mr34975084ejo.201.1560764551357;
 Mon, 17 Jun 2019 02:42:31 -0700 (PDT)
MIME-Version: 1.0
From:   Mojtaba <mespio@gmail.com>
Date:   Mon, 17 Jun 2019 14:12:19 +0430
Message-ID: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
Subject: working with libnetfilter_queue and linbetfilter_contrack
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Everyone,
I am working for a while on two projects (libnetfilter_queue and
linbetfilter_contrack) to get the decision of destined of packets that
arrived in our project. It greats to get the control of all packets.
But I confused a little.
In my solution i just want to forward all packets that are in the same
conditions (for example: all packets are received from specific
IP:PORT address) to another destination. I could add simply add new
rule in llinbetfilter_contrack list (like the samples that are exist
in linbetfilter_contrack/utility project).
But actually i want to use NFQUEUE to get all packets in my user-space
and then add new rule in linbetfilter_contrack list. In other words,
the verdict in my sulotions is not ACCEPT or DROP the packet, it
should add new rule in linbetfilter_contrack list if it is not exist.
Is it possible?
I am thinking about this, But  I am not sure it is correct or not?
For example:

static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
         struct nfq_data *nfa, void *data)
{
   uint32_t id = print_pkt(nfa);
   printf("entering callback\n");
if (not exist in list){
ct = nfct_new();
   if (ct == NULL) {
       perror("nfct_new");
   return 0;
  }
Add_to_list();
}
return;
}



-- 
--Mojtaba Esfandiari.S
