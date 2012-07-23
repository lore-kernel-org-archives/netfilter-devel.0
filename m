From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv,
 cleanup (fix gcc-4.7)
Date: Mon, 23 Jul 2012 15:04:23 +0200
Message-ID: <20120723130423.GA15807@1984>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
 <alpine.LNX.2.01.1207231418550.32073@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207231418550.32073@frira.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2012 at 02:19:11PM +0200, Jan Engelhardt wrote:
> On Monday 2012-07-23 12:38, pablo@netfilter.org wrote:
> 
> >From: Pablo Neira Ayuso <pablo@netfilter.org>
> >
> >This patch seems to be a mere cleanup that moves the parameter parsing
> >code to add_param_to_argv.
> >
> >But, in reality, it also fixes iptables whe compiled with gcc-4.7.
> 
> How does the problem manifest?

You can check:

http://bugzilla.netfilter.org/show_bug.cgi?id=774

It tastes like a memory corruption.
