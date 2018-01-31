From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix pointer leaks to userspace
Date: Wed, 31 Jan 2018 14:58:37 +0100
Message-ID: <20180131135837.44tveylwax3nju7j@salvia>
References: <20180129122120.230279-1-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        andreyknvl@google.com, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180129122120.230279-1-dvyukov@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 29, 2018 at 01:21:20PM +0100, Dmitry Vyukov wrote:
> Several netfilter matches and targets put kernel pointers into
> info objects, but don't set usersize in descriptors.
> This leads to kernel pointer leaks if a match/target is set
> and then read back to userspace.
> 
> Properly set usersize for these matches/targets.
> 
> Found with manual code inspection.

Applied, thanks!

I think this fixes:

ec2318904965 xtables: extend matches and targets with .usersize

So I'm going to add the Fixes: tag here, no problem.
