From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: Support for longest prefix IP address match in iptables?
Date: Fri, 28 Apr 2006 21:09:32 +0000 (UTC)
Message-ID: <Pine.NEB.4.62.0604282107340.14405@norge.freeshell.org>
References: <38539.192.168.20.50.1146211317.squirrel@pop-mail>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, nbasker@india.tejasnetworks.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: shyam@india.tejasnetworks.com
In-Reply-To: <38539.192.168.20.50.1146211317.squirrel@pop-mail>
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

On Fri, 28 Apr 2006 shyam@india.tejasnetworks.com wrote:

> We are using iptables to match the destination ip-addresses
> using the command
>
> iptables -t mangle -A POSTROUTING -d 10.12.13.14 -j MARK --set-mark=5
> iptables -t mangle -A POSTROUTING -d 10.12.13.0/24 -j MARK --set-mark=7

MARK is a non-terminating target, so _both_ rules get applied. The later 
one overrides the earlier one. You need to insert a rule with a 
terminating target (i.e. ACCEPT) between these.

 			Alexey
