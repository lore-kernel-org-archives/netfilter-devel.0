From: m@rtij.nl
Subject: Re: iptables modification
Date: Wed, 04 Aug 2004 10:25:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <courier.41109D63.00000AC1@ma.rtij.nl>
References: <1091580576.3949.12.camel@ben1.scorpiocc.corp>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <1091580576.3949.12.camel@ben1.scorpiocc.corp>
To: ben@scorpiocc.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ben Alabaster writes: 

> Hi, 
> 
> I need to modify my iptables module so that it will store FQDN's in the
> routing tables but I have no clue where to start.  I will give you an
> example of what I'm trying to do to better help explain.
 

You are going about it the wrong way. What you want to do is nearly 
impossible, incompatible with how things are designed and a /lot/ of work (I 
would guess manyears). 


Much easier to use a mobile IP solution which was designed to assigne a 
static IP to something which changes IP addresses underneath. I would say 
better options are:
 - Use IPv6, it has mobile IP build in.
 - Use a mobile IPV4 solution. Use google, there are many options, or simply 
write your own using ipip.
 - Use a VPN solution. Optionally leave out encryption so you end up with a 
VN solution. OpenVPN can meet your needs, others probably as well. 


HTH,
M4
-- 
Courier-mta rocks! 
