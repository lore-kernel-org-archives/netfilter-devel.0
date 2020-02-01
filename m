Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D52CC33CB3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB7D2063A
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M24a0Zry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgBAUye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 15:54:34 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:40356 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgBAUye (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 15:54:34 -0500
Received: by mail-wm1-f49.google.com with SMTP id t14so12582400wmi.5
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Feb 2020 12:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=PPRuuRsrjFPUJEeoWFbsHtpteKeVW4YfgGWOpsKNFrI=;
        b=M24a0ZryIJi/knKLUqDEKB6XJnZWS6YrRfJ5Ndnf/9zLubBg7Kj07Nj+SGc/4hqzG3
         EAvUGc45OpiWppiio+4orxJFtC8M4/w79jVEjTe2DL1rA54jF6pYFz5+d330KRcYdlwj
         dmmuOYHDLDYuxKXdtAnr9ohvb8YvAfsVeGmWXf63/votNoIMkO5B49Dg1ZwdxHLeSQDa
         urMxigvPyJUqWnYt7EPKKZw4ovfZSxl74U8huEe0PLLYW5wfPcOZUrjmonllDlnfyJZh
         P1rQFo8r88oxnGProOdHKfoVdw5lWgC61WVpfdlL6r7q/wEiwbPdwC6uwkXkrNcRZXlA
         xoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=PPRuuRsrjFPUJEeoWFbsHtpteKeVW4YfgGWOpsKNFrI=;
        b=G7T6iQ1gYpEfvNKM6FRUIFuOBo6jXnUSDNMn2Hr+PYOlzUgjGJziDWaXPMcCVqKvDe
         IZkXaZZUecDyJsJotZReRdxvXPeotC55apW718rJ2jZPUVh4qav0VXrZBnnjLoAaIuIi
         A5VcOm4AfCYVV+bDGOj6lQSpb+FkesaDgfxY5tL5fCzCxU+PoQRdnLLzl/IYMGwX6ZcX
         HYBFJ146cidFH8gRU+hATzEPxopkmRjo7UhV6WpFPyulwFJVBocK+ovlbIsNY4apUjFo
         NT0KFLSoTBJe0weAiAfpS8AQQvQUnqR25UeTS0qx7HGrEsxH4i1SwsTqes4jMc6v/744
         aROg==
X-Gm-Message-State: APjAAAVk/e4p2SxdCATpNotgCLLgrfHed2DW939cn2H/Gh4Sl7MxBSBc
        RGcJxioCixpnPN8U6ewGO6S2KFFF
X-Google-Smtp-Source: APXvYqxwp33j5+EZWYBCwNYzL1u+ufy9MMIBZos+cRN0zkzYdDXrHCRksMJy8Q6qWTqL7o682emgFQ==
X-Received: by 2002:a1c:1fd0:: with SMTP id f199mr18887760wmf.113.1580590472157;
        Sat, 01 Feb 2020 12:54:32 -0800 (PST)
Received: from p200300c27f4e7a10e48c6e1f6de71d78.dip0.t-ipconnect.de (p200300C27F4E7A10E48C6E1F6DE71D78.dip0.t-ipconnect.de. [2003:c2:7f4e:7a10:e48c:6e1f:6de7:1d78])
        by smtp.gmail.com with ESMTPSA id n16sm18281570wro.88.2020.02.01.12.54.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 12:54:31 -0800 (PST)
Message-ID: <4eb8428ee2076540dd955f5499e8701cf29b1688.camel@gmail.com>
Subject: Ipset combined entry type like hash:ip,port,ip,port
From:   Adam Kalisz <adam.kalisz@gmail.com>
To:     netfilter-devel@vger.kernel.org
Date:   Sat, 01 Feb 2020 21:54:30 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello list,

I have a use case, where I would like to save:
- src IP
- src port
- protocol
- dst IP
- dst port
- packet counter
- bytes counter

Obviously, there is obviously almost a matching type for this in ipset
hash:ip,port,ip. It just misses the destination (or source) port
depending on how you map the src and dst variables. Do I miss
something, like the possibility to concatenate entries e.g.
hash:ip,port with hash:ip,port using something like list:set? I don't
think that is the solution.
What I have is a partial workaround using two hash:ip,port,ip sets,
with one configured 'src,src,dst' and the other 'src,dst,dst' and later
combining the results - which gives the most probable quintuples.
This is less than ideal. A set in the form of hash:ip,port,ip,port
would be most helpful.

The use case is to track dynamically what client services communicated
with what server services using which protocol etc. When periodically
reading the ipset entries a reasonable monitoring of communication can
be achieved using very simple means.
The addition of entries is achieved using iptables/ nftables using:
    iptables -A FORWARD -m set ! --match-set in_conn_src src,src,dst \
    -j SET --add-set in_conn_src src,src,dst
which seems to be performant enough for my use case. (Is there any
advice concerning this?/ How efficient is this e.g. does it jump to
user space for the addition of an entry?)
The documentation seems to suggest that ipset add resets the counters.
This seems to be the case also for the -j SET target. Could you please
tell me, which code is responsible for the -j SET --add-set ?

I have the feeling, this could be a lot more efficient if the "addition
" of an already existing entry would result in the counters to be added
up. This would pretty much obviate the ! --match-set guard statement
(as shown above) and another rule just matching for accounting of the
other packets:
    iptables -A INPUT -m set --match-set in_conn_src src,src,dst

I don't know, if there is a better way using nftables with its generic
sets? Can it also add entries without jumping to user space?

Thank you for any comments on this

Adam Kalisz

