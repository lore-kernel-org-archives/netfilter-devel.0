From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: LIST_DELETE bug tracked
Date: Wed, 31 Mar 2004 17:10:39 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403311709220.21410-100000@filer.marasystems.com>
References: <20040331145833.8569.qmail@web41704.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhi wang <pangy2004@yahoo.com>
In-Reply-To: <20040331145833.8569.qmail@web41704.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, zhi wang wrote:

> In a post by KOVACS Krisztian,
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014584.html,
> he declared that the LIST_DELETE bug can be reliably
> reproduced, which is first reported by Jonathan
> Cooper. The bug is really  responsive :). I reproduced
> it by executing the following commands at my host
> 10.0.0.2:
> 1. iptables -t nat -A PREROUTING -s 10.0.0.0/24 -p tcp
> --dport 80 -j REDIRECT --to-port 8080
> 2. nc -l -p 8080
> 3. nc -n 10.0.0.2 80

Yes, this will trigger the bug.

Patch is found in the archives. Alternatively you can recompile your
kernel with local-nat support enabled which will also cure the problem.

Regards
Henrik
