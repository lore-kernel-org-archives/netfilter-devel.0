From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 04 Dec 2003 15:09:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3FCF9497.3030708@pobox.com>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com> <20031205045020.4C0E.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Feldman, Scott" <scott.feldman@intel.com>,
	Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@redhat.com>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Stephen Lee <mukansai@emailplus.org>
In-Reply-To: <20031205045020.4C0E.MUKANSAI@emailplus.org>
List-Id: netfilter-devel.vger.kernel.org

Stephen Lee wrote:
> I have a 32-bit PCI card with bcm5705 on it, does that support TSO? 
> I'll give it a try today.


I'm pretty sure tg3 does not enable TSO support by default.

Regardless, the problem is identified -- when TSO+conntrack is present,
we "TSO" net traffic then "un-TSO" it.

It's simply better to not use TSO at all, for this case.

	Jeff
