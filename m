From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH 1/3] scanner: add files in include dirs in alphabetical order.
Date: Wed, 7 Jun 2017 21:40:53 +0200
Message-ID: <CAOkSjBjeTaZTJDEViBRq2y1q715EssHUdgxOFNVf1H7JzpJ6hw@mail.gmail.com>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:34771 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdFGTlQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 15:41:16 -0400
Received: by mail-it0-f50.google.com with SMTP id m47so27687608iti.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jun 2017 12:41:15 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id r77sm1272388ioe.16.2017.06.07.12.41.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 12:41:14 -0700 (PDT)
Received: by mail-io0-f175.google.com with SMTP id y77so11502380ioe.3
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jun 2017 12:41:14 -0700 (PDT)
In-Reply-To: <20170607083559.10051-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 June 2017 at 10:35, Ismo Puustinen <ismo.puustinen@intel.com> wrote:
>
> +static int directoryfilter(const struct dirent *de)
> +{
> +       if (strcmp(de->d_name, ".") == 0 ||
> +                       strcmp(de->d_name, "..") == 0)
> +               return 0;
> +
> +       /* Accept other filenames. If we want to enable filtering based on
> +        * filename suffix (*.nft), this would be the place to do it.
> +        */
> +

This filter by suffix is good to have IMHO.
I guess that forcing users to explicitly create a file for nftables
(or at least give a specific suffix) reduces chances for user errors.
