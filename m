From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Loop Detection
Date: Sun, 15 Dec 2002 16:04:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DFC99E6.9070901@hipac.org>
References: <3DFC8933.9030607@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I wrote:
> The other definition which is tighter is:
> 
> Def2: If a packet is matched it traverses certain chains until a
>       terminal target is reached. Those chains form a path.
>       A loop exists if and only if there exists a packet whose path
>       through the chains contains some chain at least twice.

It must be stated that implementing a loop detection based on Def2
is not possible if general function based matches are used (like
netfilter does).

As we want nf-hipac to support function based matches we have in fact
no choice. Our loop detection will use Def1.
