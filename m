From: "David S. Miller" <davem@davemloft.net>
Subject: Re: memcmp() is slow?
Date: Sat, 22 Jan 2005 19:52:10 -0800
Message-ID: <20050122195210.7c9b3d3f.davem@davemloft.net>
References: <E1CsQZH-0002AE-Ob@vishnu.netfilter.org>
	<69935817.20050122213152@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <69935817.20050122213152@dns.toxicfilms.tv>
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

On Sat, 22 Jan 2005 21:31:52 +0100
Maciej Soltysiak <solt@dns.toxicfilms.tv> wrote:

> I have seen a patch that replaces memcmp() with a few comparison statements.
> The log for the change says that memcmp() is slow.
> 
> Why is it?

This is a platform specific question, as memcmp() is implemented
differently on each architecture.  So tell us what you're test
was run on. :)
