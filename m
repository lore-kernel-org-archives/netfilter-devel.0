From: James Morris <jmorris@intercode.com.au>
Subject: Re: Using -j QUEUE
Date: Tue, 26 Nov 2002 22:40:29 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0211262240130.28710-100000@blackbird.intercode.com.au>
References: <F188P1Ny1WafSqy4YkV0000addd@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: raquel toribio <raqueltoribio@hotmail.com>
In-Reply-To: <F188P1Ny1WafSqy4YkV0000addd@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 26 Nov 2002, raquel toribio wrote:

> Hello,
> I am using the following rule in iptables:
> 
> iptables -A INPUT -p TCP -j QUEUE
> 
> and I would expect all incoming tcp traffic, independently of the 
> destination IP to be fetched by my userspace program. Nevertheless, what I 
> get, is that only tcp packets destined for the linux machine arrive to the 
> userspace program. Is that the correct behaviour? If so, how should I 
> configure the iptables to get all the tcp packets independently of the 
> destination IP?
> 

You need a rule in the FORWARD chain.


-- 
James Morris
<jmorris@intercode.com.au>
