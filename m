From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] INSTALL: Update dependency list and configure with
 libxtables support
Date: Fri, 6 Oct 2017 14:40:36 +0200
Message-ID: <20171006124036.GD4713@salvia>
References: <20171005073109.19874-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005073109.19874-1-harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 05, 2017 at 01:01:09PM +0530, Harsha Sharma wrote:
> Add configure with lixtables in INSTALL and required dependencies for
> the same

Applied, thanks.

I have mangled this a bit.

Applying: INSTALL: Update dependency list and configure with libxtables support
patch:29: space before tab in indent.
        option in nft.

There is a space before tab in indent, have a look at your editor,
it's easy to spot them.

And I have modified the libxtables part to explain a bit more the
interaction between nft and the iptables-compat utility. Just follow
up if you find anything that you can improve.

Here I have enabled highlight of this and trailing whitespaces, please
have a look.

Thanks.
