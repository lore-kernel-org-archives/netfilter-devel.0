From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 31 May 2018 10:24:36 +0200
Message-ID: <20180531082436.ffd6gkbuk6xpm47y@breakpoint.cc>
References: <20180517084442.GA23981@kroah.com>
 <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
 <20180517093410.GB17597@kroah.com>
 <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
 <20180517100908.GA3150@kroah.com>
 <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
 <20180517132012.GA29160@kroah.com>
 <20180518092756.odlyvxcpgbuistqq@breakpoint.cc>
 <20180526145449.GA10379@kroah.com>
 <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Michal Kubecek <mkubecek@suse.cz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: peter pi <tiangangpi@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

peter pi <tiangangpi@gmail.com> wrote:
> Hi Greg, I applied this patch on 4.4 and tested it on my Pixel 2, it seems
> the problem still exists,

What is the problem exactly?
