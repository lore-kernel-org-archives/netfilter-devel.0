From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: memcmp() is slow?
Date: Sun, 23 Jan 2005 10:57:09 +0100
Message-ID: <1583527289.20050123105709@dns.toxicfilms.tv>
References: <E1CsQZH-0002AE-Ob@vishnu.netfilter.org>
	<69935817.20050122213152@dns.toxicfilms.tv>
	<20050122195210.7c9b3d3f.davem@davemloft.net>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050122195210.7c9b3d3f.davem@davemloft.net>
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

Hello David,

Sunday, January 23, 2005, 4:52:10 AM, you wrote:

> This is a platform specific question, as memcmp() is implemented
> differently on each architecture.  So tell us what you're test
> was run on. :)

Well, it was yoshfuji's patch that suggested the change explaining
that memcmp() is slow.

If joshfuji suggests a change like that, I think he is
pretty sure that for all archs' memcmp() of 4 integers is slower
than simply comparing them.

Anyway I was not aware of such a multiplicity of memcmp() and friends
implementations for different archs. Good to know :-)

Regards,
Maciej
