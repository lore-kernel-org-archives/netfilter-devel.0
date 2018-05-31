From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 31 May 2018 11:07:58 +0200
Message-ID: <20180531090758.gwvbzpd4iu74yakj@breakpoint.cc>
References: <20180517093410.GB17597@kroah.com>
 <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
 <20180517100908.GA3150@kroah.com>
 <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
 <20180517132012.GA29160@kroah.com>
 <20180518092756.odlyvxcpgbuistqq@breakpoint.cc>
 <20180526145449.GA10379@kroah.com>
 <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
 <20180531082436.ffd6gkbuk6xpm47y@breakpoint.cc>
 <20180531085116.GA17729@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, peter pi <tiangangpi@gmail.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Michal Kubecek <mkubecek@suse.cz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531085116.GA17729@kroah.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Thu, May 31, 2018 at 10:24:36AM +0200, Florian Westphal wrote:
> > peter pi <tiangangpi@gmail.com> wrote:
> > > Hi Greg, I applied this patch on 4.4 and tested it on my Pixel 2, it seems
> > > the problem still exists,
> > 
> > What is the problem exactly?
> 
> The problem is that kernel data is being sent to userspace due to an
> uncleared buffer that was allocated and then copied to userspace.  This
> can be reproduced by dumping the current set of iptables rules.  Peter
> had an example reproducing script that he used to specifically show
> this.  Peter, can you provide that?
> 
> I thought that initializing this buffer to zero would solve the problem,
> but I guess I cleared the wrong buffer :(

Never mind, this test was on 4.4 not 4.14.

But even on 4.14 i don't see how zeroing a buffer that will
be filled via copy_from_user would help.
