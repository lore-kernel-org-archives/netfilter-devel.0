From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc4-mm1
Date: Tue, 21 Feb 2006 02:17:32 +0100
Message-ID: <43FA6A2C.8000905@trash.net>
References: <20060220042615.5af1bddc.akpm@osdl.org>
	<43F9BDDA.1060508@reub.net> <43F9CE18.10709@trash.net>
	<20060220204456.GG4661@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20060220204456.GG4661@stusta.de>
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

Adrian Bunk wrote:
> On Mon, Feb 20, 2006 at 03:11:36PM +0100, Patrick McHardy wrote:
> 
>>Ideally this dependency should be enforced by Kconfig. I'm not sure
>>if it is possible to express something like "IP_DCCP_CCID2 and
>>IP_DCCP_CCID3 depend on DCCP, DCCP requires at least one of both
>>to be enabled". Can someone more familiar with Kconfig than me
>>comment on this? Otherwise the #error should be moved to
>>net/dccp/options.c to keep dccp.h usable without dccp enabled.
> 
> 
> I can try to do it, but I need the exact semantics.
> 
> Should all of the following stay allowed configurations?
> 
> CONFIG_IP_DCCP=y
> CONFIG_IP_DCCP_CCID2=m
> CONFIG_IP_DCCP_CCID3=n
> 
> CONFIG_IP_DCCP=y
> CONFIG_IP_DCCP_CCID2=y
> CONFIG_IP_DCCP_CCID3=m

Arnaldo apparently wants to fix it differently, but maybe you could help
us with conntrack :) CONFIG_IP_NF_CONNTRACK and CONFIG_NF_CONNTRACK
should be mutually exclusive. Specifying

CONFIG_IP_NF_CONNTRACK
	depends on CONFIG_NF_CONNTRACK=n

CONFIG_NF_CONNTRACK
	depends on CONFIG_IP_NF_CONNTRACK=n

will avoid asking for NF_CONNTRACK when IP_NF_CONNTRACK is set, but not
the other way around.
