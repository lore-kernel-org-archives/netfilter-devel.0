From: Gordan Bobic <gordan@bobich.net>
Subject: Userspace (QUEUE) Filter Verdict Targets, REJECT and TARPIT
Date: Fri, 17 Dec 2004 10:17:21 +0000
Message-ID: <200412171017.21908.gordan@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I am trying to write a configurable userspace packet filter for handling huge 
numbers of complex rules (I need it for hundreds of thousands of rules). The 
problem that I am finding is that the libipq only seems to offer ACCEPT and 
DROP verdict targets for userspace filters.

Is there a way to set REJECT or TARPIT as targets? I ask because it is nice to 
respond with REJECT to non-hostile hosts so that they don't get tied with 
connections when DROP is used. Similarly, it would be nice to be able to 
TARPIT the hostile hosts to slow them down. At the moment, the only way I can 
think of to handle this is to set a DROP verdict but then send out a custom 
made raw packet using something like libnet, but this would rather complicate 
the code I am developing (but if it's the only option, so be it, I guess).

Finally - is there a way to practically handle TARPIT in a resource-cheap way 
when conntrack is used? My packet filter needs to operate in a NAT 
enfironment, so conntrack is not something I can avoid using.

Best regards.

Gordan
