From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][1/2] New netfilter match module : kernel patch
Date: Mon, 19 Jun 2006 17:38:45 +0200
Message-ID: <4496C505.9080907@trash.net>
References: <20060602190238.92524.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alex Davis <alex14641@yahoo.com>
In-Reply-To: <20060602190238.92524.qmail@web50208.mail.yahoo.com>
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

Alex Davis wrote:
> This is an update the kernel netfilter patch that allows 
> matching the source or destination address of an IP
> packet to a network interface.

I can't see any other way to do this, but I'm not so thrilled to
add a whole new match just for this. It's not a perfect match,
but how about adding this as an option to the addrtype match
for RTN_LOCAL addresses?

Better suggestions where we can put this are welcome.
