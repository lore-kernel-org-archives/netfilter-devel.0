From: Pablo Neira <pablo@eurodev.net>
Subject: Re: iptables
Date: Thu, 22 Jan 2004 23:33:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40104FC9.5040400@eurodev.net>
References: <005101c3dc81$3e310e00$0600000a@pc6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wilmar jose wagner <wilmarw@terra.com.br>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <005101c3dc81$3e310e00$0600000a@pc6>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Wilmar jose wagner wrote:

> I migrate from iptables 1.2.7 to 1.2.9 and after the MASQUERADE     is 
> no more accepted
>  
> My syntax is:
>  
> iptables -t nat -A POSTROURING -o ppp0 -j MASQUERADE

I think that you are mistyping POSTROUTING. Anyway I think that this is 
no the correct list, please refer this problem to the netfilter user 
maillist. They will help you anyway.

cheers,
Pablo
