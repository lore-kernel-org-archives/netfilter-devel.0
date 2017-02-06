From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 2/2] netfilter: ctnetlink: Fix regression in CTA_HELP
 processing
Date: Mon, 6 Feb 2017 12:44:43 +0100
Message-ID: <20170206114443.GB15498@salvia>
References: <20170126224944.29047-1-cernekee@chromium.org>
 <20170126224944.29047-2-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dianders@chromium.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170126224944.29047-2-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 26, 2017 at 02:49:44PM -0800, Kevin Cernekee wrote:
> Prior to Linux 4.4, it was usually harmless to send a CTA_HELP attribute
> containing the name of the current helper.  That is no longer the case:
> as of Linux 4.4, if ctnetlink_change_helper() returns an error from
> the ct->master check, processing of the request will fail, skipping the
> NFQA_EXP attribute (if present).
> 
> This patch changes the behavior to improve compatibility with user
> programs that expect the kernel interface to work the way it did prior
> to Linux 4.4.  If a user program specifies CTA_HELP but the argument
> matches the current conntrack helper name, ignore it instead of generating
> an error.

Also applied, thanks Kevin.
