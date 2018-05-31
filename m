From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 31 May 2018 13:23:11 +0200
Message-ID: <20180531112311.GA29517@kroah.com>
References: <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
 <20180517100908.GA3150@kroah.com>
 <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
 <20180517132012.GA29160@kroah.com>
 <20180518092756.odlyvxcpgbuistqq@breakpoint.cc>
 <20180526145449.GA10379@kroah.com>
 <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
 <20180531082436.ffd6gkbuk6xpm47y@breakpoint.cc>
 <20180531085116.GA17729@kroah.com>
 <CANZU63VE7fWNL+PJrLp7-5PBS6R6RQPvhw2QgqAK8NhX4uQc9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
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
In-Reply-To: <CANZU63VE7fWNL+PJrLp7-5PBS6R6RQPvhw2QgqAK8NhX4uQc9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 31, 2018 at 05:40:40PM +0800, peter pi wrote:
> Hi Greg,
> 
> My test method is very simple:
> 1, In copy_to_user, add a function call like my_examine(from, n) to check
> every 8 bytes. There is an kernel function called  virt_addr_valid which
> can check if the value is a address value.
> 2, Print a kernel log when there is a leak detected in function my_examine
> 3, Run iptables-save or ip6tables-save in shell, it will hit the kernel
> code path of the problem
> 
> 
> Because my test code is specified for Pixel 2, so I think you can write the
> test code yourself just about 10 lines code

Any chance you can test this on a more modern kernel, like 4.14 or
newer on a normal system?

thanks,

greg k-h
