From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH 2.6 NETFILTER] new netfilter module ipt_program.c
Date: Mon, 13 Sep 2004 13:50:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <182842767.20040913135002@dns.toxicfilms.tv>
References: <20040911124106.GD24787@lkcl.net>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040911124106.GD24787@lkcl.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

> decided to put this into a separate module.  based on ipt_owner.c.
> does full program's pathname.  like ipt_owner, only suitable for
> outgoing connections.
What if ipt_program could calculate a some sort of a checksum for
the file to make it more difficult for evil doers to exploit the
simple path match?

If someone replaces a file so it's path+name stays the same but
has a different checksum and is evil, the rule would not much.

Might be more secure. It could be an option to calc checksums.
It could be an option not to calc checksums.

What do you think?

Regards,
Maciej
