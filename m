From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 15:04:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1095861889.17821.1337.camel@hades.cambridge.redhat.com>
References: <2GFBZ-61e-11@gated-at.bofh.it> <2GSfS-6eW-5@gated-at.bofh.it>
	 <2H0ZO-49v-13@gated-at.bofh.it> <2HdDL-48z-53@gated-at.bofh.it>
	 <2HdNp-4eJ-27@gated-at.bofh.it>  <m37jqmeby9.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Marc Ballarin <Ballarin.Marc@gmx.de>,
	Linus Torvalds <torvalds@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S265395AbUIVOFT@vger.kernel.org>
To: Andi Kleen <ak@muc.de>
In-Reply-To: <m37jqmeby9.fsf@averell.firstfloor.org>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-09-22 at 14:15 +0200, Andi Kleen wrote:
> > Ever heard of iptables?
> 
> Except that it doesn't have usable 32bit emulation on x86-64.
> 32bit userland on x86-64 kernel cannot use iptables, they have
> to use ipchains.
> 
> I would ask for to not drop ipchains until this is fixed.

Agreed. The iptables compatibility with 32-bit userspace is completely
broken.

-- 
dwmw2
