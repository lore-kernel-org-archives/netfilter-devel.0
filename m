From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH for 2.6.33] conntrack: restrict runtime hashsize
 modifications
Date: Wed, 03 Feb 2010 15:50:52 -0500
Message-ID: <1265230252.2861.321.camel@tonnant>
References: <20100203203929.GA6168@x200>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net, eric.dumazet@gmail.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100203203929.GA6168@x200>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2010-02-03 at 22:39 +0200, Alexey Dobriyan wrote:
> Jon Masters correctly points out that conntrack hash sizes
> (nf_conntrack_htable_size) are global (not per-netns) and
> modifiable at runtime via /sys/module/nf_conntrack/hashsize .

Thanks.

Jon.


