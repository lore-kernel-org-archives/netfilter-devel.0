From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New patches
Date: Tue, 18 Jan 2005 13:53:37 +1100
Message-ID: <1106016817.30801.30.camel@localhost.localdomain>
References: <00be01c4fc0c$ddd6b760$5746370a@nsp.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: VeNoMouS <venom@gen-x.co.nz>
In-Reply-To: <00be01c4fc0c$ddd6b760$5746370a@nsp.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2005-01-17 at 09:49 +1300, VeNoMouS wrote:
> Ive written a bidirectional matching patch and rewritten the quota
> patch to include packet header length as well into the quota these
> patches can be found at http://www.gen-x.co.nz/patches/ Ive included a
> patch for iptables-1.2.11 for the bidirectional match perhaps these
> can be entered into PoM?

OK, first step is to grab the latest subversion tree and patch against
that.  Secondly, I'd suggest:

1) Rename to "bidir" since "bidirectional" is a little long,
2) Use a single structure, rather than separating into two.
3) Don't define "IP", use *flags = 1, and you don't need to check
   for it anywhere else.

You might want to consider the merits of allow TCP/UDP ports, too.  I
don't know if this is a good idea or even has clear semantics.

Cheers,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
