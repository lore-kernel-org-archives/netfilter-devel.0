From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tc filtering vs iptables
Date: Fri, 27 Aug 2004 17:54:41 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
References: <1093614389.1068.20.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
In-Reply-To: <1093614389.1068.20.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 27 Aug 2004, jamal wrote:

> Let me know how to create proper chains for a range of hosts
> {1,2,8, 64,256,4096,8192,16384,32768,64K}

For very many unique hosts in iptables it is better to use an ippool for 
matching the source IP, or to look into using hipac.

ippool has the benefit that it allows you to create a group of hosts where 
the lookup is relatively fast to determine if the IP is among those hosts 
or not.

The benefit of hipac is that any kind of lookup is fast with no need to 
arrange the ruleset in a special mannner.

Regards
Henrik
