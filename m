From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: bridge: define INT_MIN & INT_MAX in userspace
Date: Thu, 25 Oct 2018 10:25:18 +0200
Message-ID: <20181025082518.yxvnoxfyr7qqpxyh@salvia>
References: <20181024115403.3938-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181024115403.3938-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 24, 2018 at 01:54:03PM +0200, Jiri Slaby wrote:
> With 4.19, programs like ebtables fail to build when they include
> "linux/netfilter_bridge.h". It is caused by commit 94276fa8a2a4 which
> added a use of INT_MIN and INT_MAX to the header:
> : In file included from /usr/include/linux/netfilter_bridge/ebtables.h:18,
> :                  from include/ebtables_u.h:28,
> :                  from communication.c:23:
> : /usr/include/linux/netfilter_bridge.h:30:20: error: 'INT_MIN' undeclared here (not in a function)
> :   NF_BR_PRI_FIRST = INT_MIN,
> :                     ^~~~~~~
> 
> Define these constants by including "limits.h" when !__KERNEL__ (the
> same way as for other netfilter_* headers).

Applied, thanks.
