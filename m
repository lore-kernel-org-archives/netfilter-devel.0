From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH/RFC] core/netfilter.c: possible use of freed skb
Date: Wed, 30 Jul 2003 16:56:15 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030730165615.2549a92a.davem@redhat.com>
References: <200307271655.15937.bdschuym@pandora.be>
	<20030727155030.2ce4e22e.davem@redhat.com>
	<20030730140626.GB4553@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030730140626.GB4553@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jul 2003 16:06:29 +0200
Harald Welte <laforge@netfilter.org> wrote:

> On Sun, Jul 27, 2003 at 03:50:30PM -0700, David S. Miller wrote:
> 
> > This patch looks OK to me, can I get an ACK from the
> > netfilter folks?
> 
> Dave, the patch looks fine to me.

Applied, thanks guys.
