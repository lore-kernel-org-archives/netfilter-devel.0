From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ip_queue & QUEUE target
Date: 15 Jun 2003 20:50:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055703009.3199.14.camel@tux.rsn.bth.se>
References: <20030615155352.GD2103@lbsd.net> <3EECA7B2.5090300@trash.net>
	 <20030615180031.GE2103@lbsd.net> <3EECB5F4.7010004@trash.net>
	 <20030615183504.GG2103@lbsd.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nigel Kukard <nkukard@lbsd.net>
In-Reply-To: <20030615183504.GG2103@lbsd.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-06-15 at 20:35, Nigel Kukard wrote:

> What about DIVERT sockets, would these be reliable?

If you are only using the packets to generate statistics I'd say ULOG is
what you want. It's quite cpu efficient. It batches packets together
before sending them to userspace, and copies only as much of the packets
as you specify.

-- 
/Martin
