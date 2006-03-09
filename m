From: "David S. Miller" <davem@davemloft.net>
Subject: Re: {get|set}sockopt compat layer
Date: Thu, 09 Mar 2006 15:29:34 -0800 (PST)
Message-ID: <20060309.152934.99760924.davem@davemloft.net>
References: <200603071707.19138.dim@openvz.org>
	<200603071605.39177.arnd@arndb.de>
	<200603091324.00362.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: arnd@arndb.de, akpm@osdl.org, dev@openvz.org,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org, devel@openvz.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751965AbWCIX3n@vger.kernel.org>
To: dim@openvz.org
In-Reply-To: <200603091324.00362.dim@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Dmitry Mishin <dim@openvz.org>
Date: Thu, 9 Mar 2006 13:23:59 +0300

> Hello, Arnd!
> 
> > For the compat_ioctl stuff, we don't have the function pointer inside an
> > #ifdef, the overhead is relatively small since there is only one of these
> > structures per module implementing a protocol, but it avoids having to
> > rebuild everything when changing CONFIG_COMPAT.
> >
> > It's probably not a big issue either way, maybe davem has a stronger
> > opinion on it either way.
> >
> Done.

I think this looks fine but it doesn't apply cleanly to the
current net-2.6.17 tree.

Could you cook up a fresh patch, and send it with a complete
changelog entry and appropriate Signed-off-by: lines?

Thanks a lot Dmitry.
