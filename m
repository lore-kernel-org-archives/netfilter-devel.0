From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] uapi: fix linux/netfilter/xt_hashlimit.h userspace
 compilation error
Date: Sat, 25 Feb 2017 13:33:37 +0100
Message-ID: <20170225123337.GA25870@salvia>
References: <20170224002320.GA31010@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170224002320.GA31010@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 24, 2017 at 03:23:20AM +0300, Dmitry V. Levin wrote:
> Include <linux/limits.h> like some of uapi/linux/netfilter/xt_*.h
> headers do to fix the following linux/netfilter/xt_hashlimit.h
> userspace compilation error:
> 
> /usr/include/linux/netfilter/xt_hashlimit.h:90:12: error: 'NAME_MAX' undeclared here (not in a function)
>   char name[NAME_MAX];

Applied, thanks.
