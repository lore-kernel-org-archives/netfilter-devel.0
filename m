From: Piotrek Kaczmarek <kaczorek@k.daleka.net>
Subject: Re: accounting NAT-ed packets
Date: Sun, 19 Dec 2004 23:48:50 +0100
Message-ID: <20041219224850.GA25652@daleka.net>
References: <20041219101257.GA16236@daleka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20041219101257.GA16236@daleka.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Dec 19, 2004 at 11:12:57AM +0100, Piotrek Kaczmarek wrote:
> Hello,
> 
> I want to account all traffic from the address assigned to the linux box
> (including NAT, locally generated traffic), but i can't. The rule
> iptables -t mangle -A POSTROUTING -s 213.25.213.42
> seems not to ,,catch'' NAT-ed packets, only locally generated traffic.
> 
> Is there any method to ,,catch'' packets after NAT with netfilter?

I've found a solution. I've added POSTROUTING chain to the raw table but with
higher priority than a nat table, so it is now possible to intercept
packets with nat-ed source addresses. You can download patch from
http://k.daleka.net/iptable_raw.patch

Could you consider applying this? I couldn't find other solution to do this.

-- 
Piotrek Kaczmarek
