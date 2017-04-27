From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call print/save
Date: Thu, 27 Apr 2017 07:33:19 -0400
Message-ID: <CA+FuTSfC+Wp+uZo4F+Z0R=OnM8929SZb+zAw3TgUyqUQyv-NZw@mail.gmail.com>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
 <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu> <CAF=yD-+agqtwhkc+pQV+68K0pZiFZX13GcQZVR_Tv7SM_zkmZQ@mail.gmail.com>
 <CAF=yD-LkPtRVuUVmeOCJYaqmRCAKkPDkuxVV4QT_YsDOCfKpyg@mail.gmail.com>
 <CAF=yD-JSEfRFQWfKf+S_SzOkhYYhMgPYTzBmHO7J5iU47nFHrg@mail.gmail.com> <alpine.DEB.2.11.1704271114480.21354@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, anubis@iwwd.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33225 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753956AbdD0Ldx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 07:33:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id y10so3951150wmh.0
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Apr 2017 04:33:52 -0700 (PDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com. [74.125.82.49])
        by smtp.gmail.com with ESMTPSA id 47sm3012206wry.31.2017.04.27.04.33.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Apr 2017 04:33:50 -0700 (PDT)
Received: by mail-wm0-f49.google.com with SMTP id w64so14140315wma.0
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Apr 2017 04:33:50 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.11.1704271114480.21354@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> > It may be more subtle than what you describe. xtables_find_match
>> > can call xtables_fully_register_pending_match which calls
>> > compatible_match_revision to decide whether a match revision
>> > is supported and, if multiple revisions are supported, which to prefer.
>>
>> The case reported in bugzilla is for match 'set', which has not had a
>> new revision since v4 in 2014. Building the exact versions of iptables
>> and ipset reported there and disabling v4 support in the kernel correctly
>> reverts to using v3.
>
> Maybe the case can be reproduced with the following steps, but I'm
> guessing:
>
> - rules inserted
> - iptables binary downgraded/upgraded
> - rules listed

It will. This is largely what the patch protects against. But perhaps
it currently unnecessarily restricts binaries that support both
revisions N and N + 1 from printing structs of rev N, if those
are inserted from another binary that only supported up to N. Let
me try that.

Before this patch, a rule inserted with a binary that only supports
rev N for a given match, but read with another binary that supports
rev N+1 will result in the new binary incorrectly parsing a struct of
rev N as one of rev N + 1. And vice versa. See also the discussion in

  Re: [PATCH nf-next] netfilter: xt_bpf: support ebpf
  https://www.spinics.net/lists/netfilter-devel/msg45357.html

Casting structs in this way is unsafe. The downgrade path cannot
be fixed. But the upgrade path should. The way iptables negotiates
with the kernel and only loads the highest revision for any given
match or target may make this hard to change.
