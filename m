From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: iptables doubt
Date: Thu, 13 Apr 2006 18:04:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0604131801560.4261@mercury.sdinet.de>
References: <443D06A7.1060504@rocsys.com> <443E21C1.9090508@info.ucl.ac.be>
	<443E341F.1080206@rocsys.com> <443E42E6.2010405@info.ucl.ac.be>
	<443E4BAA.3020607@rocsys.com> <443E4F34.10206@info.ucl.ac.be>
	<443E57E6.8080005@rocsys.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
In-Reply-To: <443E57E6.8080005@rocsys.com>
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

On Thu, 13 Apr 2006, varun wrote:

>                         The features i want to implement like that priority 
> for policy is that imagine a scenario where user added some policies and then 
> for some reason wants one policy to be checked before checking others then he 
> would have to add the policy again and delete the old policy isint it?

Every iptables rule change is loading the whole ruleset into userspace, 
modifying it, and copying the result back into kernelspace.

So you should be able to fetch the rules (f.e. with iptables-save), modify 
them as you like, and push them back (iptables-restore).

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
