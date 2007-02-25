From: Patrick McHardy <kaber@trash.net>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Sun, 25 Feb 2007 20:03:36 +0100
Message-ID: <45E1DD88.6080206@trash.net>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>	 <45E04468.7020001@trash.net> <45E06546.504@redhat.com>	 <45E1C7E0.9070102@trash.net> <1172428694.4485.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Chuck Ebbert <cebbert@redhat.com>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965105AbXBYTDk@vger.kernel.org>
In-Reply-To: <1172428694.4485.31.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> What about this case:
> 
> 1. Conntrack entry is created and placed on the unconfirmed list
> 2. The event cache bumps the refcount of the conntrack entry
> 3. module removal of ip_conntrack unregisters all hooks
> 4. packet is dropped by an iptables rule
> 5. packet is freed but we still have a refcount on the conntrack entry
> 
> Now there's no way to get that refcount to decrease as that only happens
> when the event cache receives another packet or the current packet makes
> it through the stack as you wrote above. And neither of this will happen
> since we unregistered the hooks providing the packets and dropped the
> packet.

The event cache is flushed on conntrack module unload after the hooks
have been unregistered, which should release all references.
