From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netns: add and use net_ns_barrier
Date: Mon, 19 Jun 2017 19:10:40 +0200
Message-ID: <20170619171040.GB4975@salvia>
References: <20170530093812.10712-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170530093812.10712-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 30, 2017 at 11:38:12AM +0200, Florian Westphal wrote:
> Quoting Joe Stringer:
>   If a user loads nf_conntrack_ftp, sends FTP traffic through a network
>   namespace, destroys that namespace then unloads the FTP helper module,
>   then the kernel will crash.
> 
> Events that lead to the crash:
> 1. conntrack is created with ftp helper in netns x
> 2. This netns is destroyed
> 3. netns destruction is scheduled
> 4. netns destruction wq starts, removes netns from global list
> 5. ftp helper is unloaded, which resets all helpers of the conntracks
> via for_each_net()
> 
> but because netns is already gone from list the for_each_net() loop
> doesn't include it, therefore all of these conntracks are unaffected.
> 
> 6. helper module unload finishes
> 7. netns wq invokes destructor for rmmod'ed helper

Applied, thanks everyone.
