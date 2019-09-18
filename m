Return-Path: <SRS0=T2b5=XN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7548DC4CEC9
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BF821848
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSTsyn3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfIRCxW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:53:22 -0400
Received: from mail-vk1-f173.google.com ([209.85.221.173]:39607 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIRCxW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:53:22 -0400
Received: by mail-vk1-f173.google.com with SMTP id u4so1201455vkl.6
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2019 19:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Z6X215MvJQ7TBdcJ6siDoEFM/+vEMam1c6oliRUVUYg=;
        b=mSTsyn3Va+D9HVCT450zRx9d3e2vlClhYb3za3C2AFkcwKdHnDWA6Z3HVOpu9PjESP
         pWznmYA2APPwR89ISCxkAexq+i5aN2fFxhrNPKv+7MsO/YgTHl6u/K/bRwxSEobfHQeb
         ktkL6+oVxTQZbuakE3OvqudztjDIZknmvD5Ty5CDkF6ar/REp5rAKsRoKswUM0hKRPj+
         ukRrjpyr42TclTHXgErX5mJcIfAq0/ng3XptnkFyr4IBf2NH9ythJRgkwbS5g5KO5Onb
         h/zSMJ+W1giKJ/R2feELtlHgIX5q6AFRewlrsfi/MQY0Iqitc4LbnITx+UdKS75gNCMW
         Z7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Z6X215MvJQ7TBdcJ6siDoEFM/+vEMam1c6oliRUVUYg=;
        b=djz1MI4oVNOsLnJuDhhi3zITwdcCaFRDeXJGdbN9XFPtBITmIOxrpfUfecCd4PhRn9
         T1jt8I7XojaHcoHAPD79aFS44dTqiYt/RIBEg4iUokoX6hFEkA5tlk3H0GdxSlKo2uu/
         wf2KARF68eouvos8529UU5EdRCoSc/haY0P5yeM82xLWoU4hvn8BBSF64m87z8aWO+I+
         WJF/FZFa/7ML7LAuU1viV09IijxeBgXrMkwANIAiYcKv0tTYG+xQ+69uvJt/jBOZUiXi
         qC6yX/2BJGSfSfbCJd6ecxJFvYc83T7KqUoVrYFhd8KnX31dwyEI5cK5zvaQw8XIBBWK
         CpSA==
X-Gm-Message-State: APjAAAVBJsmkhakqQWIfdi8Eeu3/Og5SJ3DChRzy+iIZmbpVDb3pkCu5
        BJDLrF8Wb0z80+jKB/ZOqXWuL36kXduCCHARftHasyl9g8Y=
X-Google-Smtp-Source: APXvYqzp4WdhArIq1AkGXhIAtnCoiJ+378BrSySGeUvyNa4l4RYj4sfnVTU9ag5QLzxbJ69SOUuMim1h9Nq6FmHKXGw=
X-Received: by 2002:a1f:c55:: with SMTP id 82mr956557vkm.9.1568775199995; Tue,
 17 Sep 2019 19:53:19 -0700 (PDT)
MIME-Version: 1.0
From:   Olivia Nelson <the.warl0ck.1989@gmail.com>
Date:   Wed, 18 Sep 2019 10:53:09 +0800
Message-ID: <CAJZVxRm=-htSywNjtQKnUYoTeEXoTqcxgNbRabEE22FSQwW9jg@mail.gmail.com>
Subject: icmp_hdr is wrong on CentOS 6 kernels (2.6.32-754.12.1)
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have a simple netfilter module to test icmp_hdr function:

unsigned int hook_func(
    unsigned int hooknum,
    struct sk_buff *skb,
    const struct net_device *in,
    const struct net_device *out,
    int (*okfn)(struct sk_buff *))
{
    const struct iphdr *ip_header = ip_hdr(skb);
    if (ip_header && ip_header->protocol == IPPROTO_ICMP)
    {
        const struct icmphdr *icmp_header = icmp_hdr(skb);
        printk(KERN_INFO "ICMP type %d", icmp_header->type);
    }

    return NF_ACCEPT;
}

Then I start to PING the HOST.

On CentOS 6 (2.6.32-754.12.1.el6.x86_64), he printed ICMP type is
always 69 (INVALID).
On CentOS 7 (3.10) the result is ICMP_ECHO (8), which is correct.

Was it a bug?
