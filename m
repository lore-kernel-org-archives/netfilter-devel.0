From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Mon, 29 Jan 2018 19:24:01 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1801291917130.15985@n3.vanv.qr>
References: <001a1144b0caee2e8c0563d9de0a@google.com> <201801290020.w0T0KK8V015938@www262.sakura.ne.jp> <20180129072357.GD5906@breakpoint.cc> <20180129082649.sysf57wlp7i7ltb2@node.shutemov.name> <20180129165722.GF5906@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        aarcange@redhat.com, yang.s@alibaba-inc.com, mhocko@suse.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, linux-mm@kvack.org, rientjes@google.com,
        akpm@linux-foundation.org, guro@fb.com,
        kirill.shutemov@linux.intel.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:52226 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750959AbeA2SYD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jan 2018 13:24:03 -0500
In-Reply-To: <20180129165722.GF5906@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2018-01-29 17:57, Florian Westphal wrote:
>> > > vmalloc() once became killable by commit 5d17a73a2ebeb8d1 ("vmalloc: back
>> > > off when the current task is killed") but then became unkillable by commit
>> > > b8c8a338f75e052d ("Revert "vmalloc: back off when the current task is
>> > > killed""). Therefore, we can't handle this problem from MM side.
>> > > Please consider adding some limit from networking side.
>> > 
>> > I don't know what "some limit" would be.  I would prefer if there was
>> > a way to supress OOM Killer in first place so we can just -ENOMEM user.
>> 
>> Just supressing OOM kill is a bad idea. We still leave a way to allocate
>> arbitrary large buffer in kernel.

At the very least, mm could limit that kind of "arbitrary". If the machine has
x GB (swap included) and the admin tries to make the kernel allocate space for
an x GB ruleset, no way is it going to be satisfiable _even with OOM_.

>I think we should try to allocate whatever amount of memory is needed
>for the given xtables ruleset, given that is what admin requested us to do.
