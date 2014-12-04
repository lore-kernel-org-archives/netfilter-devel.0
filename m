From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Reversed byte order issue with nft ?
Date: Thu, 4 Dec 2014 14:27:21 +0100
Message-ID: <20141204132721.GA10863@salvia>
References: <547F467B.3060206@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <547F467B.3060206@c-s.fr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 03, 2014 at 06:20:59PM +0100, leroy christophe wrote:
> Hi,
> 
> When doing 'nft list ruleset', I get a bad result (see below),
> fields appear as "unknown" and/or as numeric values.

Please, test this:

http://patchwork.ozlabs.org/patch/417775/

and confirm that this resolves your problem. Thank you.
