From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.11.2 1/1] ipt_sctp chunk map definition too large
Date: Wed, 09 Mar 2005 22:30:39 +0100
Message-ID: <422F6AFF.4050602@trash.net>
References: <422F69BB.3010301@jetfuelsoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Tim Ozor <tozor@jetfuelsoftware.com>
In-Reply-To: <422F69BB.3010301@jetfuelsoftware.com>
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

Tim Ozor wrote:
> Greetings,
> 
> In the process of implementing a native Java iptables API, I discovered 
> a bug in the ipt_sctp.h header file where the chunkmap is defined too 
> large. This obviously does not affect execution, but will result in 
> increased memory useage in libiptc, or in my case the java process.

Unfortunately we can't fix it this way since it breaks userspace
compatiblity. You might be able to retain compatiblity using Rusty's
new revision stuff, but I doubt it's worth it.

Regards
Patrick
