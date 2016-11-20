From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter question
Date: Sun, 20 Nov 2016 09:31:37 -0800
Message-ID: <1479663097.8455.367.camel@edumazet-glaptop3.roam.corp.google.com>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
         <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
         <20161116150200.GH30581@breakpoint.cc>
         <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
         <20161117000725.GK30581@breakpoint.cc>
         <1479623583.8455.358.camel@edumazet-glaptop3.roam.corp.google.com>
         <CAGUFhKwQTRRJpfGi2fRkFfGdpLYMN-2F9G+dEsavM7UGbkjjdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Eric D <ericd@miromedia.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33176 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcKTRbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 12:31:39 -0500
Received: by mail-pg0-f67.google.com with SMTP id 3so26128098pgd.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Nov 2016 09:31:39 -0800 (PST)
In-Reply-To: <CAGUFhKwQTRRJpfGi2fRkFfGdpLYMN-2F9G+dEsavM7UGbkjjdA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2016-11-20 at 12:22 -0500, Eric D wrote:
> I'm currently abroad for work and will come back home soon. I will
> test the solution and provide feedback to Florian by end of week.
> 
> Thanks for jumping on this quickly.
> 
> Eric
> 
> 
> On Nov 20, 2016 7:33 AM, "Eric Dumazet" <eric.dumazet@gmail.com>
> wrote:
>         On Thu, 2016-11-17 at 01:07 +0100, Florian Westphal wrote:
>         
>         > +     if (state->mem == NULL) {
>         > +             state->mem = __alloc_percpu(PAGE_SIZE,
>         PAGE_SIZE);
>         > +             if (!state->mem)
>         > +                     return false;
>         > +     }
>         
>         This will fail on arches where PAGE_SIZE=65536
>         
>         percpu allocator limit is PCPU_MIN_UNIT_SIZE  ( 32 KB )
>         
>         So maybe use a smaller value like 4096 ?
>         
>         #define XT_PCPU_BLOC_SIZE 4096
>         
Thanks Eric, I will test the patch myself, because I believe we need it
asap ;)




