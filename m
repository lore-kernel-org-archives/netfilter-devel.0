From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4.x] Fix ipchains MASQUEARDE oops
Date: Thu, 4 Dec 2003 10:36:03 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204103603.333f3a7b.davem@redhat.com>
References: <20031204093757.GA7680@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031204093757.GA7680@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Dec 2003 15:07:57 +0530
Harald Welte <laforge@netfilter.org> wrote:

> Please apply the following patch (on top of 2.4.23).  It fixes an oops
> that was introduced during  2.4.23 when we did a change in the NAT core
> but forgot to update the compatibility layer.  2.6.x already contains
> that fix.
> 
> Please apply, thanks.

Applied, thanks Harald.

> Which raises another issue... do you think it would still be possible to
> rip out the ipfwadm and ipchains compatibility layer from 2.6.x?  I'm
> just _asking_, if it was still possible - not asking you to do it.

I think we could have done this say 2 or 3 months ago.  I would
have supported such a move.  But now is certainly too late.

Put it on your 2.7.1 TODO list :)
