From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: RE: Need a method to reset the ip_conntrack_count
Date: Thu, 13 Oct 2005 19:59:02 +0800
Message-ID: <009701c5cfed$80ad3180$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter@lists.netfilter.org>, "'Netfilter Development Mailinglist'"
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: 
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

Hi,

Can I use the conntrack tools written by Harald Welte/Pablo Neira Ayuso
to flush the conntrack entries currently. 
And then I can reset the ip_conntrack_count which described as the
following problem.

And do we have the individual patch based on kernel 2.6.10 for the teses
contrack packages?

Thanks in advance

Vincent

> -----Original Message-----
> From: Vincent [mailto:cs83152@csie.chu.edu.tw] 
> Sent: Thursday, October 13, 2005 5:32 PM
> To: 'netfilter@lists.netfilter.org'
> Subject: Need a method to reset the ip_conntrack_count
> 
> 
> Hello folks,
> 
> I have encountered one question. Does it have a way to flush 
> the conntrack table beside reloading the ip_conntrack module  
> (because I use the method of building into kernel.
> 
> As far as I know, the current conntrack number was recorded 
> in the /proc/sys/net/ipv4/netfilter/ip_conntrack_count
> So I want to know whether it exists a method or not to reset 
> the current counter of conntrack.
> 
> My Enviroment:
> Kenel: 2.6.10
> Iptables: 1.2.9
> 
> Any hint are appreciated.
> 
> Vincent
> 
> 
