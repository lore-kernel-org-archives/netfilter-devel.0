From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend [patch 2/2] iptables: add random option to SNAT
Date: Mon, 12 Feb 2007 14:40:13 +0100
Message-ID: <45D06E3D.4070008@trash.net>
References: <1170681950.5631.4.camel@localhost.localdomain>	
	<45C747D9.102@trash.net>
	<1170690933.5631.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1170690933.5631.11.camel@localhost.localdomain>
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

Eric Leblond wrote:
>>I'll look into the userspace patch
>>after that, I'm not a big fan of the :random syntax.
> 
> 
> I make this choice because iptables had the capabilities to have
> multiple NAT ranges and hence randomization has to be linked with the
> range.

Not anymore since since rustynat changes (~2.6.12).

> 
> But we can also assume to have a per iptables rule switch. I can rewrite
> my patch in this way if you want.

I think I would prefer that.
