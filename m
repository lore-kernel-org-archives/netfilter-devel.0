Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505A5C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 13:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354864AbiDBNCS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 09:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354867AbiDBNCQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 09:02:16 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFD213F32
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 06:00:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id e16so9369292lfc.13
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2022 06:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NVljAahrPUHS9tmWpw4L0hOUrYOq3sVcyjX8B1G9uHE=;
        b=HFH7V0375y6R4CUrQDesaGpkMNo7YpZBVjKQNddPYbrRpDY7Zr5D77nv1K+HcIkAWS
         fzrYNcmWU2m1FcAwvxdXFwGQCw+hYl6ViVwU6+eB5BvYCmpIUsQ+pbif4scxvUR27ks3
         gmtncmM7TdM5soxWbsUu/4EcvxPr1ibfZR0Y/PxX5sP2ZiF/UF5GySbWVItVzUZlNUvC
         ZLvf0ajHC+yuGiG/DLAvogTkbovp1d6s2Q/AfH6qd1KgYFRKdwSLJZMm1rL6GLsY+BTt
         R4kniptAraxPGIOlbGumtM77F6vmIXehZOlhtLA+EalkPq0lILuYDad+iDnThEoOFDgX
         AS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NVljAahrPUHS9tmWpw4L0hOUrYOq3sVcyjX8B1G9uHE=;
        b=dtDBtMVqvZcwfgfn7cIdUpeSW+nnW/OId3sYQF3oPqUcBi0C5jtrPRlEZU7RJ0n69T
         BOQWJJdo9Aa0ufBSykTO9Y1PI8hYvOFVsuRtnUvQvdZZp/YTrrrw2ItAMnKEOHQvSxAO
         ngObs/w/YAGHdZUBfn4Xg9wiIi+hQRmtUmWmcavZ1QvhpAs5SCNmUN7H9jXaGSkRQSzD
         d0oZvp9x/Qq8CUkF34wryybtSCec+KMUrvxtQESmsCvdbRCmENOtLAqjtln3mj6AqW66
         a2ess1axZTaXE1n3+01GNvm6XtE8k2sBYg0in7dahOEnl3+O+ynye0OKiIiIZg/OKgiI
         2xnQ==
X-Gm-Message-State: AOAM532rIV5sSGtBzErcG2eagTFJ4+8D0fgfZGyxtbX6U9313XuxAZgI
        xtFJE0gyH/zkHTSjNzCc834u9Q==
X-Google-Smtp-Source: ABdhPJzG6bOF3UtCVGz5LisECPp2wCtWPHEQm94DQuGcMAwh2iR87RH0/djnZEllRl8TCDC7jdwVbA==
X-Received: by 2002:a05:6512:3b8f:b0:44a:7f61:46c6 with SMTP id g15-20020a0565123b8f00b0044a7f6146c6mr16954748lfv.109.1648904420211;
        Sat, 02 Apr 2022 06:00:20 -0700 (PDT)
Received: from [192.168.112.17] (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id b19-20020a056512305300b0044a9638b343sm521079lfb.303.2022.04.02.06.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 06:00:19 -0700 (PDT)
Message-ID: <12e761e2-4e2a-55b6-1b9f-b465f27ddd85@openvz.org>
Date:   Sat, 2 Apr 2022 16:00:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: troubles caused by conntrack overlimit in init_netns
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, Vasily Averin <vvs@openvz.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
 <20220402111157.GD28321@breakpoint.cc>
From:   Nikita Yushchenko <nikita.yushchenko@openvz.org>
In-Reply-To: <20220402111157.GD28321@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi

 > But, why do you need conntrack in the container netns?

Container can hold a default installation of a linux distro, that often enables firewall and adds rules 
that trigger conntrack. But, that is inside container's netns. That is accounted separately and is not 
part of the issue being discussed.

The issue is that traffic directed to container(s) eats out host's conntrack limit, and causes the host 
to be inaccessible via network.

 >> Do you know perhaps some alternative solution?
 >
 > If you need conntrack in init_net, then no.

I suppose this can be fixed by something like:
- adding some "window" on top of host's conntrack limit,
- if out of conntracks, but still within window, conntrack shall be created but marked,
- mark could be removed by a dedicated netfilter rule,
- attaching more than one skb to marked conntrack shall be blocked (i.e. packet dropped instead),
- if skb pointing to a marked conntrack is about to leave the stack (that is, either being delivered 
locally, or queued for transmitting out), it shall be dropped instead, and conntrack removed.

This shall give host's admin a way to explicitly configure a packat path to use as a host management 
interface, that will stay accessible even if containers eat out conntrack limit.

Is that reasonable?  Maybe I can try to implement that...

Nikita
