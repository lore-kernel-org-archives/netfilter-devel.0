From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Follow packets in rules
Date: Wed, 13 Jun 2007 10:57:26 +0200
Message-ID: <466FB176.7040306@netfilter.org>
References: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Fabrice Rafart <fabrice.rafart@efs.sante.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
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

Fabrice Rafart wrote:
> I look for a tool to follow a packets into rules of netfilter.
> 
> For example :
> 
> # iptables-test -s 192.168.1.1 -d 192.168.2.1 -p tcp --dport 25
> --> FORWARD line 1  : -p tcp --dport 25 -j SMTP
> --> SMTP line 3     : -s 192.168.1.0/24 -j DROP
> 
> This show me which rules matches the packet until the end.
> 
> Does this exist ?

check nfsim: http://ozlabs.org/~jk/projects/nfsim/

AFAIK, it's not actively maintained so probably you'll have to hack on 
it a bit.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
