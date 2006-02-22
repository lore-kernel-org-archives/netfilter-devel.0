From: Patrick McHardy <kaber@trash.net>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Wed, 22 Feb 2006 07:17:15 +0100
Message-ID: <43FC01EB.50308@trash.net>
References: <BAY109-DAV3F52AAA9FA589FA356BFAB3FD0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV3F52AAA9FA589FA356BFAB3FD0@phx.gbl>
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

Jing Min Zhao wrote:
> Hi, all,
> 
> I've written a new H.323 conntrack & NAT helper module for Netfilter.
> 
> I have five years experience in H.323 development and many years in Linux
> development, so I know many people out there need Linux firewall to support
> H.323 as IP phones are becoming more and more popular. I also know Jozsef
> Kadlecsik and Max Kellermann have written such Netfilter modules, but they
> don't support RAS, Fast-Start and H.245 tunnelling. However, these features
> are essential for most modern H.323 devices. Many carriers even don't
> support slow-start at all.

This is great news. I'm actually currently working on an improved
version of the H.323 tracker myself, my version also supports
Fast-Start and Tunneling, but I'm still working on RAS tracking.
Since I'm missing you're 5 years H.323 experience, there's a good
chance that your version is better, I'll have a closer look today.
