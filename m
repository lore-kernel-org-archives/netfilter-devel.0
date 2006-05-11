From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Re: how to i fwd bcast?
Date: Thu, 11 May 2006 09:51:48 -0400
Message-ID: <44634174.8020205@certicom.com>
References: <44632F32.7080400@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
In-Reply-To: <44632F32.7080400@rocsys.com>
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

Perhaps someone else will correct me, but you cannot forward bcast packets using
iptables and network interfaces.

You can redirect bcast to the local machine via REDIRECT target. You can DNAT
bcast, but again only to local machine addresses. Everything else and the packet
disappears.

To fwd bcast you will need to create an ethernet bridge between your (2)
interfaces via brctl. If you wish to filter bcast packets you can use ebtables.
I believe that iptables also work with bridges.

Chinh

http://www.certicom.com/

varun wrote:
> Hi all,
> 
>             Can anyone tell me how to fwd udp bcast packets from one n/w
> to another using iptables?
> 
> Varun
> 
