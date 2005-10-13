From: Jerry Alexander <jerrya@airmail.net>
Subject: IPSec and Netfilter
Date: Thu, 13 Oct 2005 16:39:59 -0500
Message-ID: <434ED42F.6040707@airmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Jerry <jerry@mavenir.com>
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

Dear NF devel:

         Have just currently  written a user library to implement 
iptables filter and NAT commands.
         Also have written a kernel module that hooks into the PREROUTE 
hook to intercept
packets and collect stats on the IP packet addresses that have been 
entered into iptables.
         Manager just came by and asked me if  Netfilter is above or 
below where IPSEC
resides.    Only know the minimal about IPSEC at this time.  I believe 
his concern is
that  say in tunnel mode,  an IPSEC IP header is built and the contents 
are encrypted and
if Netfilter is below  IPSEC  routing and statistics gathering won't work.
         From browsing the internet,  it appears with the correct 
"iptables NAT command"
that the packet routing will occur correctly.
         I also assume that  when I try to read the packets at the 
PREROUTE point that
it will be the decrypted packet and my statistics gathering will work.
        So far the documentation I have found is not clear on this.
        Could someone knowledgeable in this area please clearify.

                                                                   Thanks,
                                                                             
Jerry
