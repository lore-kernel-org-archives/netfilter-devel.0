From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Trivial 2.6 tftp conntrack fix
Date: Sun, 24 Aug 2003 04:25:12 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824042512.352ffc9c.davem@redhat.com>
References: <20030822153414.84E262C0C4@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030822153414.84E262C0C4@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 21 Aug 2003 01:00:10 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> D: In 2.6, the TFTP conntrack helper returns -1 if the packet is too
> D: short, but that is an invalid return code.  Return NF_ACCEPT
> D: instead.

Applied, thanks Rusty.
