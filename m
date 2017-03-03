From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH] ipv6: Preserve link scope traffic original oif
Date: Fri, 3 Mar 2017 12:56:50 +0100
Message-ID: <CAF1oqRD9sahqwj0u1k44x6EqnjD7czLFDM32nO1o6am4gnprtw@mail.gmail.com>
References: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com> <20170303113918.GA13435@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:33002 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdCCL5i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 06:57:38 -0500
Received: by mail-yw0-f177.google.com with SMTP id s15so55506552ywg.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 03:56:51 -0800 (PST)
In-Reply-To: <20170303113918.GA13435@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 3, 2017 at 12:39 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 01, 2017 at 02:47:23PM +0100, Alin Nastac wrote:
>> Link-local and multicast packets must keep their original oif after
>> ip6_route_me_harder is called.
>
> Out of curiosity, how does the setup you use look like to trigger this
> problem?

ICMPv6 RA/NS/NA are marked by a -j MARK iptables rule (the mark value
is used to set the QoS queue).
Because skb->mark value changed, ip6t_mangle_out will call ip6_route_me_harder.
