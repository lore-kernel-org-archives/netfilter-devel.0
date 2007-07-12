From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: tcpmss match for IPv6 ?
Date: Thu, 12 Jul 2007 23:44:38 +0200
Message-ID: <4696A0C6.6040905@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Hello,

I hope this is the right list for my question.
Support of the TCPMSS target for IPv6 was recently added in the kernel 
and ip6tables. It can help fixing some MTU blackhole issues, so thanks. 
However there is currently no support of the tcpmss match for IPv6 yet, 
although xt_tcpmss.c in the kernel seems to be IPv6 compatible.

Has anyone already submitted a patch to add support for an IPv6 tcpmss 
match in ip6tables ? It seems trivial to derive from the existing IPv4 
tcpmss match for iptables. I believe I could even do it although I am 
not a software developper and don't know how to submit a patch.

I ask because I would have a use for an IPv6 tcpmss match in conjunction 
with the IPv6 TCPMSS target. "-j TCPMSS --clamp-mss-to-pmtu" may not be 
optimal, still allowing underlying fragmentation at a lower layer 
because of encapsulation (e.g. my ISP uses IPv6 over PPP over L2TP over 
UDP over IP over ethernet, where the optimal non-fragmenting IPv6 MTU is 
1460 due to the PPP+L2TP+UDP+IP overhead). Lowering the MTU is not an 
option, as I want to keep the ability to send and receive as big packets 
as the link allows. "-j TCPMSS --set-mss 1400" could be used to prevent 
TCP connections from causing fragmentation of the L2TP packets, but I 
must check that the original MSS is above 1400 before changing it. Else 
it would increase the MSS, which is not desirable. So I would need the 
tcpmss match in order to check the original MSS. Another solution would 
be a new "--clamp-mss <value>" option in the TCPMSS target which would 
clamp (i.e. decreases if higher) the MSS down to an arbitrary value 
instead of a value based on the PMTU. But I feel it would be more 
complicated.

Thanks for your attention.
