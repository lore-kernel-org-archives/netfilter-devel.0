From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix removal of GRE expectation entries
 created by PPTP
Date: Tue, 10 Nov 2015 17:39:11 +0100
Message-ID: <20151110163911.GA3161@salvia>
References: <1447173390-2993-1-git-send-email-pablo@netfilter.org>
 <1447173390-2993-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447173390-2993-2-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 10, 2015 at 05:36:29PM +0100, Pablo Neira Ayuso wrote:
> From: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> 
> The uninitialized tuple structure caused incorrect hash calculation
> and the lookup failed.

Please, ignore this.

This patch is already in the nf tree, it just slipped through in my
last git send-email.
