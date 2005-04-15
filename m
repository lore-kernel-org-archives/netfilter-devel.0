From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: arbitary length matchinfo
Date: Fri, 15 Apr 2005 17:23:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504151721130.30308@filer.marasystems.com>
References: <425FA638.5010601@evtek.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Juha Heljoranta <juha.heljoranta@evtek.fi>
In-Reply-To: <425FA638.5010601@evtek.fi>
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

On Fri, 15 Apr 2005, Juha Heljoranta wrote:

> Is it possible to create arbitary length matchinfo?

Not without modifying both libiptc and the kernel. The structures does 
support this, but libiptc assumes the matchinfo is of fixed size, and the 
kernel also verifies the size is the expected size.

> What I want is an path:

Just curious: why?

Regards
Henrik
