From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Sun, 12 Feb 2017 15:46:09 +0100
Message-ID: <CAOkSjBjA3L4aiqNOYOJm+yEVa9+j6Ls649_ibvTjZh1WL8MCew@mail.gmail.com>
References: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi> <20170212140900.GA10250@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36826 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdBLOqb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 09:46:31 -0500
Received: by mail-it0-f65.google.com with SMTP id f200so8757479itf.3
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 06:46:30 -0800 (PST)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id 2sm569454itc.25.2017.02.12.06.46.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Feb 2017 06:46:29 -0800 (PST)
Received: by mail-io0-f171.google.com with SMTP id j18so76005254ioe.2
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 06:46:29 -0800 (PST)
In-Reply-To: <20170212140900.GA10250@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 February 2017 at 15:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'll let Eric decide to this small update.
>

Perhaps it would be good idea to drop this file from our tree and let
distros adjust this.
