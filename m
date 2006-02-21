From: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.16-rc4-mm1
Date: Tue, 21 Feb 2006 03:00:12 +0100
Message-ID: <20060221020012.GU4661@stusta.de>
References: <20060220042615.5af1bddc.akpm@osdl.org>
	<43F9BDDA.1060508@reub.net> <43F9CE18.10709@trash.net>
	<20060220204456.GG4661@stusta.de> <43FA6A2C.8000905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43FA6A2C.8000905@trash.net>
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

On Tue, Feb 21, 2006 at 02:17:32AM +0100, Patrick McHardy wrote:
> 
> Arnaldo apparently wants to fix it differently, but maybe you could help
> us with conntrack :) CONFIG_IP_NF_CONNTRACK and CONFIG_NF_CONNTRACK
> should be mutually exclusive. Specifying
> 
> CONFIG_IP_NF_CONNTRACK
> 	depends on CONFIG_NF_CONNTRACK=n
> 
> CONFIG_NF_CONNTRACK
> 	depends on CONFIG_IP_NF_CONNTRACK=n
> 
> will avoid asking for NF_CONNTRACK when IP_NF_CONNTRACK is set, but not
> the other way around.


Even worse, kconfig will complain about a circular dependency.


CONFIG_IP_NF_CONNTRACK

CONFIG_NF_CONNTRACK
	depends on CONFIG_IP_NF_CONNTRACK=n


CONFIG_IP_NF_CONNTRACK will be visible if CONFIG_NF_CONNTRACK is set, 
but as soon as CONFIG_IP_NF_CONNTRACK is set, CONFIG_NF_CONNTRACK is 
automatically set to n.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
