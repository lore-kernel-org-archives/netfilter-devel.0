From: Christophe Jelger <Christophe.Jelger@unibas.ch>
Subject: Full header rewrite before local delivery
Date: Mon, 06 Aug 2007 16:44:56 +0200
Message-ID: <46B733E8.20803@unibas.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi all,

I'm doing some research on MANETs and I'm working on a Linux kernel 
module (called LUNAR) that forwards packets based on an MPLS-style 
forwarding scheme using local labels. One aspect of this scheme is that 
IP addresses are not used for routing and only have local-scope because 
the MPLS "circuits" are setup with DNS names. Basically we keep IP for 
"backwards compatibility", i.e. because everything works today in an 
IP-by-default mode.

Now when a packet reaches its destination the IP header is all wrong 
because each node locally maintains its own "view" of the MANET: thus I 
first have to NAT the IP header before I deliver the packet to the IP 
stack. Note I have to NAT both the source and destination addresses. 
This works fine but the problem is that I don't want to re-write all the 
nice NAT-ALGs such as for FTP, SIP, etc.

This means I'd like to use ip_tables to do this full NAT but it seems 
that with the existing code one can only do SNAT in the postrouting 
while I need to do that before local delivery to the IP stack. Also I'd 
still like to use existing modules to NAT FTP, SIP, etc ...

I have now spent quite some time looking at the ip_tables code and I 
have to admit I'm still quite lost and I'm not sure what is best to 
solve my problem. Basically if I still do the IP header NAT myself 
(which is fine for me), how can I then pass the half-NATed packet to the 
ip_tables ALGs to take care of FTP and other application-level data?

I guess another solution would be to let ip_tables do the full-NAT (IP 
header + app data) but SNAT can only be used in POSTROUTING and I want 
to do that before the packet is delivered to the IP stack ...

Any help/hint would be greatly appreciated.

thanks in advance and best regards,
Christophe

-- 
--------------------------------------------------
Dr. Christophe Jelger, http://cn.cs.unibas.ch
University of Basel, Departement Informatik
Bernoullistrasse 16, CH-4056 Basel, Switzerland
