From: Marc Ballarin <Ballarin.Marc@gmx.de>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Tue, 21 Sep 2004 14:36:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
References: <1095721742.5886.128.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267632AbUIUMfh@vger.kernel.org>
To: "Rusty Russell (IBM)" <rusty@au1.ibm.com>
In-Reply-To: <1095721742.5886.128.camel@bach>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Sep 2004 09:09:02 +1000
"Rusty Russell (IBM)" <rusty@au1.ibm.com> wrote:

> Name: Warn that ipchains and ipfwadm are going away
> Status: Trivial
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Start off with a warning for 2.6.9, so any remaining users have a
> chance to migrate.  Their firewall scripts might not check return
> values, and they might get a nasty surprise when this goes away.

Isn't a compile-time warning a bit "soft"? Especially when compilation of
a kernel easily produces > 100 warnings, as it does right now.

Regards
