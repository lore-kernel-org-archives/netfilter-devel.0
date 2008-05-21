From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Wed, 21 May 2008 19:18:04 +0200
Message-ID: <4834594C.5030704@trash.net>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

James Morris wrote:
> The following patch implements a new "security" table for iptables, so
> that MAC (SELinux etc.) networking rules can be managed separately to
> standard DAC rules.
> 
> This is to help with distro integration of the new secmark-based
> network controls, per various previous discussions.
> 
> The need for a separate table arises from the fact that existing tools
> and usage of iptables will likely clash with centralized MAC policy
> management.
> 
> The SECMARK and CONNSECMARK targets will still be valid in the mangle
> table to prevent breakage of existing users.

Thanks James, just one question:

> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -365,6 +365,17 @@ config IP_NF_RAW
>  	  If you want to compile it as a module, say M here and read
>  	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
>  
> +# security table for MAC policy
> +config IP_NF_SECURITY
> +	tristate "Security table"
> +	depends on IP_NF_IPTABLES
> +	default m if NETFILTER_ADVANCED=n

Is the table also useful without CONFIG_SECURITY? Otherwise
I'd suggest to add a dependency.
