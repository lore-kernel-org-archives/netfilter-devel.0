From: "David S. Miller" <davem@redhat.com>
Subject: Re: netfilter IPv6 support
Date: Thu, 26 Aug 2004 13:00:24 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040826130024.6ff83dff.davem@redhat.com>
References: <1093546367.3497.23.camel@hostmaster.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Zehetbauer <thomasz@hostmaster.org>
In-Reply-To: <1093546367.3497.23.camel@hostmaster.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Aug 2004 20:52:47 +0200
Thomas Zehetbauer <thomasz@hostmaster.org> wrote:

> Although linux was one of the first to support IPv6 it seems to me that
> netfilter support has almost stuck. There is still not even a REJECT
> target not to mention stateful filtering for IPv6.

Why not ask the netfilter development lists such questions?

Stateful netfilter is not there because it's a total waste
to completely duplicate all of the connection tracking et al.
code into ipv6 counterparts when %80 of the code is roughly
the same.  People are working on a consolidation of these
things so that there is no code duplication but it is a lot
of work and there are bigger fires to put out at the moment.
