Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E99FC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 10:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2293D2082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 10:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQ5q78bj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfCRKUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:20:12 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:41491 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfCRKUJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 06:20:09 -0400
Received: by mail-qk1-f176.google.com with SMTP id o129so9242866qke.8;
        Mon, 18 Mar 2019 03:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sSHqRW7sJKxqIa/v0+CX4jlRjlbd5klDL0lzlrn1kVI=;
        b=PQ5q78bjhrLXk6K55wKqwpV5ngCfWQPvw7paEtEoxxQlh33ZLal91JOXpaXf6mJMvK
         5kh4s2zKUdhgdRlmyvqCSX1ZnDdW3Iy+8LbFNPNb3eyzqnCrXE8sTNRfDLtzY59ih+bB
         h4HR2SqmHhTKxq48VTyP9cq//kOVDYLgFWqVNJ/zueCVbUVwG6556CuMtTqR4fZDnvDk
         EjubTnMAvaD2yJFCLBlAf7WmhKnKZsfqu3YaGck1iBYCG6ZbJeRhQpLeDa/mcYZgfIzU
         XWM6rNR8iiio75GB+uvHEr/4pEXL1lElO4w4mHhEmeOHCOcOn8FY0ZhvzWvKZKFSoPdO
         fTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sSHqRW7sJKxqIa/v0+CX4jlRjlbd5klDL0lzlrn1kVI=;
        b=rMKAJuCkh6jIFK/xOF3xR5wmxHO2o70etg0WTAy1eNFzVkUsF+HwI0HuGWjEI+HGG7
         3+y4VDPP3xwoX3SlEY2Gar6AMJZUzZkSoPULCRMVa+OFERBTEZId2Z+Lz9NEzdkJK96o
         0ToJFbmjt0FIanuiUIa+WSUHcvC/E3Ej1rfiEYfa/79BGpnB6llAMAgvZ0/m7RRGxRHr
         Xeyy0t+s53CcK0+1O6CuCTIy3v4u88c3ZiE86HH1M8KpRr37csXvIm/bEPHy2ulBAZJc
         p30UyfY/UOvqEiprS7MTcB6RDkxEIOtAHbhiVaYffGJ/1wj+13kKlWb+0mA7Ax4tfUNw
         dUOA==
X-Gm-Message-State: APjAAAWZfNUG+N87qFRV8Ywk8iUNjJrWhTL9bVP+okWE8cj9KlKrwBiS
        7eNkNccK6Z4fJVeWX/ZDnS8CBjyjVr3qf63u/dE02AKM
X-Google-Smtp-Source: APXvYqzAJRG0zlWjKYb19utcjEqUGBxgrQnQ/jfMX1aJ8JfnT/V33GgvkhKhnO8tcmq7hDLkQfEannPjIX7mYLY8/qc=
X-Received: by 2002:a37:5e82:: with SMTP id s124mr12584280qkb.156.1552904407606;
 Mon, 18 Mar 2019 03:20:07 -0700 (PDT)
MIME-Version: 1.0
From:   Laura Garcia <nevola@gmail.com>
Date:   Mon, 18 Mar 2019 11:19:56 +0100
Message-ID: <CAF90-WiG3FOzNkFV+v=5O=hJevNoj44pk=kTVZP=mgr22=WwzA@mail.gmail.com>
Subject: [ANNOUNCE] nftlb 0.4 release
To:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

I'm honored to present

    nftlb 0.4

nftlb stands for nftables load balancer, a user space tool
that builds a complete load balancer and traffic distributor
using the nft infrastructure.

nftlb is a nftables rules manager that creates virtual services
for load balancing at layer 2, layer 3 and layer 4, minimizing
the number of rules and using structures to match efficiently the
packets. It comes with an easy JSON API service to control,
to monitor and to automate the configuration.

Most important changes in this version are:
* Security Policies per virtual service including:
 - White and blacklisting
 - Queuing packets to user space
 - TCP flow validation
 - Maximum of established connections
 - TCP resets per second allowed
 - Limit of new connections per service
* Configurable hashing parameters based on source/destination ip
address, source/destination port, source/destination MAC address, or
combinations of them.
* Configurable persistence for client-backend affinity with a timeout
based on source/destination ip address, source/destination port,
source/destination MAC address, or combinations of them.

For further details, please refer to the official repository:

https://github.com/zevenet/nftlb

You can download this tool from:

https://github.com/zevenet/nftlb/releases/tag/v0.4

Happy load balancing!

--
Detailed changelog:

New features
- farms: add persistence between client and backend during a timeout
- policies: support of security policies per virtual service
- farms: support of queuing packets to user space per service
- farms: support of tcp flow validation per service
- farms: support of max established connections per virtual service
per source address
- farms: support of tcp resets per second allowed per virtual service
per source address
- farms: support of new connections limit per second per virtual
service and optional burst
- farms: add configurable hashing parameters
- src: support of delete all farms at once

Improvements
- nft: refactor farm rules generation code
- server: add long body support
- config: parsing json values hardening
- nft: fix helpers rules according to protocol
- readme: update the new parameter tcp-strict to avoid bogus tcp attacks
- farms: enable mac discovery for stateless dnat
- main: hide the key parameter when the process is running for security reasons
- nft: separate services by interface name for ingress modes
- farms: force the network data reload when changing the virtual ip
- farm: set masquerade if source addr is empty
- nft: add prerouting filter chain for marking and helpers
- buffer: remove debug messages
- farm: set default scheduler parameter for hash algorithm only
- config: use string keys as much as possible
- readme: add stateless nat mode option
- tests: allow launch of one single test without service
- buffer: fix code identation
- backends: only actionable if the backend is available
- backends: declare actionable functions
- buffer: support of scalable buffer
- backends: enable restart of backends after configuration
- nft: apply reset action per farm and backends
- nft: generalize actions for add or deletion postrouting elements
- farms: rename farm source-addr attribute instead of src-addr
- config: print marks in hex format
- tests: support to launch tests through web api
- build: move -lev to LDADD
- build: move preprocessor flags to CPPFLAGS

Bugfixes
- config: return error when an object has not been selected
- backends: avoid go to config_error after setting dnat ip addresses
- nft: fix stateless dnat rules when the input and output interfaces
are different
- nft: fix service name for stateless nat
- backend: fix backend validation during automated mac address request
- network: protect double free in handle
- server: fix double free segfault
- backends: fix backend validation when applying dsr mode
- farms: strim virtual interfaces for ingress chains
- nft: fix add element filter rules in reload
- nft: fix stateless dnat rules actions
- nft: avoid the use of filter chain and backend marks for ingress
- nft: avoid empty rules in filter chain when there is no backends
- backends: apply reload if changing the state of a backend
- nft: fix skb mark insertion from ct mark in filter chain
- nft: fix flush and delete chain filter
- nft: fix delete filter service and chain
- nft: fix delete elements from filter chain
- nft: avoid rules generation if there is no backend available
- backends: fix backend availability for ingress modes
- logs: fix set log level at startup
- objects: avoid buffer copy overlap
- buffer: fix typo in error message
- backends: fix backend going down
- Remove config.h file from .gitignore
- src: fix string copy sizes
- src: add a cleanup parsing structures to avoid null objects references
- config: fix farm mark json dump
- server: fix parse input body that produces buffer parsing error
