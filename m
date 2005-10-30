From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] connmark requires ip_conntrack
Date: Sun, 30 Oct 2005 16:20:17 +0100
Message-ID: <4364E4B1.5000809@trash.net>
References: <43557DF1.60207@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Piotr Chytla <pch@packetconsulting.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43557DF1.60207@eurodev.net>
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

Pablo Neira wrote:
> Hi Patrick,
> 
> The connmark match/target require ip_conntrack to work. This patch add 
> such dependency via need_ip_conntrack(). Thanks to Piotr Chytla for 
> spotting this problem.

For the CONNMARK target it makes sense. As for matches,
I don't really like loading modules where semantically
something else (like assuming 0) would also make sense,
but I've applied the patch for consistency reasons with
other matches. Thanks.
