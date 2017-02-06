From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 1/2] netfilter: ctnetlink: Fix regression in
 CTA_STATUS processing
Date: Mon, 6 Feb 2017 12:44:32 +0100
Message-ID: <20170206114432.GA15498@salvia>
References: <20170126224944.29047-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: dianders@chromium.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170126224944.29047-1-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 26, 2017 at 02:49:43PM -0800, Kevin Cernekee wrote:
> The libnetfilter_conntrack userland library always sets IPS_CONFIRMED
> when building a CTA_STATUS attribute.  If this toggles the bit from
> 0->1, the parser will return an error.  On Linux 4.4+ this will cause any
> NFQA_EXP attribute in the packet to be ignored.  This breaks conntrackd's
> userland helpers because they operate on unconfirmed connections.
> 
> Instead of returning -EBUSY if the user program asks to modify an
> unchangeable bit, simply ignore the change.
> 
> Also, fix the logic so that user programs are allowed to clear
> the bits that they are allowed to change.

Applied, thanks Kevin.

I have manually fixed here this compilation warning, btw:

net/netfilter/nf_conntrack_netlink.c:1449:1: warning:
‘ctnetlink_update_status’ defined but not used [-Wunused-function] ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
 ^
