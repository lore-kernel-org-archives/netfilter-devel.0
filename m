From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Compiling 1.3.6
Date: Mon, 09 Oct 2006 17:36:54 +0200
Message-ID: <452A6C96.2070102@netfilter.org>
References: <00be01c6e977$1ba6bcd0$0101a8c0@pcjorge>
	<452979F7.9090205@netfilter.org> <452A6955.6020100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jorge Bastos <mysql.jorge@decimal.pt>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <452A6955.6020100@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>min_ip and max_ip type has been changed from u_int32_t to __be32 that is
>>not defined in userspace, this breaks iptables compilation. Attached a
>>patch that recovers the use of u_int32_t. I'm not sure if this is the
>>best fix so let me know what you think.
> 
> 
> I think we should just define the endian-annotation types in userspace.
> Does this patch fix compilation?

But this breaks previous iptables version with new kernels :(. An 
alternative can be exporting ipt_iprange.h to iptables/include although 
this is also a hack.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
