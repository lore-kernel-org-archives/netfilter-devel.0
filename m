From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: allow logging from non-init
 namespaces
Date: Thu, 2 Feb 2017 14:25:22 +0100
Message-ID: <20170202132522.GA8215@salvia>
References: <20170131093006.5C750A0EED@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170131093006.5C750A0EED@unicorn.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 31, 2017 at 10:30:06AM +0100, Michal Kubecek wrote:
> Commit 69b34fb996b2 ("netfilter: xt_LOG: add net namespace support for
> xt_LOG") disabled logging packets using the LOG target from non-init
> namespaces. The motivation was to prevent containers from flooding
> kernel log of the host. The plan was to keep it that way until syslog
> namespace implementation allows containers to log in a safe way.
> 
> However, the work on syslog namespace seems to have hit a dead end
> somewhere in 2013 and there are users who want to use xt_LOG in all
> network namespaces. This patch allows to do so by setting
> 
>   /proc/sys/net/netfilter/nf_log_all_netns
> 
> to a nonzero value. This sysctl is only accessible from init_net so that
> one cannot switch the behaviour from inside a container.

Applied, thanks Michal!
