From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Unable to use MARK target with iptables-1.3.7
Date: Wed, 07 Feb 2007 17:03:01 +0100
Message-ID: <45C9F835.7080806@netfilter.org>
References: <1170863326.4250.20.camel@andybev.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Blake Covarrubias <blake@ekalb.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1170863326.4250.20.camel@andybev.localdomain>
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

Andrew Beverley wrote:
> When I try to use the MARK target with iptables 1.3.7:
> 
> iptables -t mangle -A POSTROUTING -p tcp --dport 22 -j MARK \
> --set-mark 10
> 
> I get:
> 
> FATAL: Module ip_tables not found.
> 
> Is this a bug with 1.3.7 or am I doing something wrong?

Weird, this message comes from modprobe that is invoked by iptables.
Does iptables -L -n show the rule that you just inserted?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
