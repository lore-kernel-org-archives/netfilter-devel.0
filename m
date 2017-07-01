From: Greg KH <greg@kroah.com>
Subject: Re: [4.11.y,netfilter] please, cherry-pick 87e94dbc210a
Date: Sat, 1 Jul 2017 16:11:15 +0200
Message-ID: <20170701141115.GA8136@kroah.com>
References: <20170629145134.GA5075@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629145134.GA5075@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 29, 2017 at 04:51:34PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Please, cherry-pick this commit:
> 
> commit 87e94dbc210a720a34be5c1174faee5c84be963e
> Author: Eric Leblond <eric@regit.org>
> Date:   Thu May 11 18:56:38 2017 +0200
> 
>     netfilter: synproxy: fix conntrackd interaction
> 
> [ For other stable maintainers: This patch applies from 3.16 onwards. ]

Now applied, thanks!

greg k-h
