From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Constify option struct
Date: Wed, 4 Oct 2017 16:08:26 +0200
Message-ID: <20171004140826.GA8450@salvia>
References: <1506512692-7872-1-git-send-email-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506512692-7872-1-git-send-email-harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 27, 2017 at 05:14:52PM +0530, Harsha Sharma wrote:
> The struct of type option is only used to initialise a field inside
> the xtables_globals struct and is not modified anywhere.
> Done using following coccinelle semantic patch

Applied, thanks.
