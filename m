From: Patrick McHardy <kaber@trash.net>
Subject: Re: [linuximq] Re: [PATCH] pom-ng version of IMQ target (file is
 attached this time)
Date: Wed, 02 Jun 2004 01:17:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BD0E6E.7040608@trash.net>
References: <40A29E4A.94165870@info-link.net> <40A2D9D8.2050201@trash.net> <40A39C34.639DC30E@info-link.net> <40BB2C43.90704@dsl.pipex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linuximq@yahoogroups.com,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Furniss <andy.furniss@dsl.pipex.com>
In-Reply-To: <40BB2C43.90704@dsl.pipex.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Andy Furniss wrote:
> I am still not sure whether using Dummy will satisfy other IMQ users 
> though, the thread above just deals with my setup - using ingress IMQ. 
> There must be people on here using IMQ for egress/ multiple IMQs to 
> solve their own problems. I changed IMQ to hook before NAT for egress, 
> just to see if it worked, as someone on the LARTC list wanted to use 
> ESFQ for a large NATed LAN - it appears to be OK - but will a netfilter 
> independent replacement allow this sort of flexability?

It probably could, but I don't know how the dummy device receives it's
packets, so I don't know if you can make it see the real source IP.

Your mail made me realize I need patch for exactly the same issue
with ESFQ for work, so if you need it I can send it to you.

Regards
Patrick

> 
> Andy.
> 
