From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables-translate: add escape_quotes option
 to comment_xlate
Date: Thu, 18 Aug 2016 17:59:30 +0200
Message-ID: <CAAaDf4vWgD74bME7fBjErHud6zV0=tWrOf6ouNe_GHiEUFYU+Q@mail.gmail.com>
References: <20160816174433.28272-1-pablombg@gmail.com> <20160817142317.GA9755@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35335 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753925AbcHSDqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:39 -0400
Received: by mail-io0-f195.google.com with SMTP id q83so4062161iod.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 20:46:39 -0700 (PDT)
In-Reply-To: <20160817142317.GA9755@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-08-17 16:23 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Aug 16, 2016 at 07:44:32PM +0200, Pablo M. Bermudo Garay wrote:
>> The comment_xlate function was not supporting this option that is
>> necessary in some situations.
>
> I have applied what I'm attaching to this email, that is more simple
> than this and makes sure buffer is nul-terminated (given snprintf
> doesn't guarantee this).

Ok, the simplification seems great. But AFAIK both standards (C99+ and
POSIX.1-2001+) guarantee that the string will be null-terminated. Am I
wrong about that?
