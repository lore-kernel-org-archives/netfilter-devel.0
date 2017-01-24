From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/2] restore original default of nf_conntrack_helper
 sysctl
Date: Tue, 24 Jan 2017 02:28:59 +0100
Message-ID: <20170124012859.GA6375@salvia>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
 <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiri Kosina <jikos@kernel.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 23, 2017 at 05:09:55PM -0800, Linus Torvalds wrote:
> On Mon, Jan 23, 2017 at 4:06 PM, Jiri Kosina <jikos@kernel.org> wrote:
> >
> > Considering this being really close to the "userspace breakage"
> > borderline, I'm CCing Linus as well.
> 
> For all I know, there may be some security reason why we really don't
> want the automatic helpers, even if they can be convenient.

Yes, with helper modules in place, this is known to allow attackers to
push holes in your firewall.  Eric Leblond actually show that it's
perfectly feasible to exploit this via handcrafted packets [1]. The
problem is documented here [2].

> Also, you can just enable them with a kernel command line or a sysctl,
> so it's not like you can't get the old behavior back.

Right.

[1] https://cansecwest.com/csw12/conntrack-attack.pdf
[2] https://home.regit.org/netfilter-en/secure-use-of-helpers/
