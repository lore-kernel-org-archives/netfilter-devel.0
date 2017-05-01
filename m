From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/53] Netfilter/IPVS updates for net-next
Date: Mon, 1 May 2017 12:53:53 +0200
Message-ID: <20170501105353.GA24620@salvia>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 01, 2017 at 12:46:27PM +0200, Pablo Neira Ayuso wrote:
> Hi David,
> 
> The following patchset contains Netfilter updates for your net-next
> tree. A large bunch of code cleanups, XXX they are:

Oh well, it case you can amend XXX thing there, David. This should be
instead...

The following patchset contains Netfilter updates for your net-next
tree. A large bunch of code cleanups, simplify the conntrack extension
codebase, get rid of the fake conntrack object, speed up netns by
selective synchronize_net() calls. More specifically, they are:

...

Sorry, it seems my robot took some incomplete draft.
