From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: Problem with snat.
Date: Mon, 17 Jul 2017 08:22:21 +0200
Message-ID: <CAOkSjBin_=55oxx=HdY9aLAdE4vC0NJt8ne1kT4H470E82T0qA@mail.gmail.com>
References: <366821a9f3ba0d10162c23ef0e2c27e8@inwebse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: sorcus@inwebse.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38308 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdGQGWn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 02:22:43 -0400
Received: by mail-it0-f52.google.com with SMTP id h199so13173899ith.1
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jul 2017 23:22:42 -0700 (PDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com. [209.85.214.43])
        by smtp.gmail.com with ESMTPSA id j186sm5230194itj.11.2017.07.16.23.22.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jul 2017 23:22:41 -0700 (PDT)
Received: by mail-it0-f43.google.com with SMTP id m84so47316990ita.0
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jul 2017 23:22:41 -0700 (PDT)
In-Reply-To: <366821a9f3ba0d10162c23ef0e2c27e8@inwebse.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 July 2017 at 00:07,  <sorcus@inwebse.com> wrote:
> Can you confirm that a bug or not?
>
> https://serverfault.com/questions/861375/what-wrong-with-snat-in-nftables
> http://marc.info/?t=149969788400002&r=1&w=2
> https://github.com/NixOS/nixpkgs/issues/27093
>
> No one can help me. And i don't know what i need doing now.

You are probably lacking the reply NAT chain, which needs to be registered.

https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)

I'm updating right now the wiki to put this in bold.
