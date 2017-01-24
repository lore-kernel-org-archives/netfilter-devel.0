From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/2] restore original default of nf_conntrack_helper sysctl
Date: Mon, 23 Jan 2017 17:09:55 -0800
Message-ID: <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz
To: Jiri Kosina <jikos@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 23, 2017 at 4:06 PM, Jiri Kosina <jikos@kernel.org> wrote:
>
> Considering this being really close to the "userspace breakage"
> borderline, I'm CCing Linus as well.

For all I know, there may be some security reason why we really don't
want the automatic helpers, even if they can be convenient.

Also, you can just enable them with a kernel command line or a sysctl,
so it's not like you can't get the old behavior back.

Do networking people have any comments? Was there a reason to actually
switch the default? Because the commit messages aren't all that
helpful.

               Linus
