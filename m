From: Dmitry <dg@ipcb.net>
Subject: Symmetric NAT for udp
Date: Thu, 17 Nov 2005 15:00:53 +0300
Message-ID: <437C70F5.2090401@ipcb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all - i have a trouble with making netfilter nat act like symmetric 
for udp . Normally for udp  it acts like port restricted cone nat ( the 
main feature is that it doesnt mangle src port if several udp packets 
come from same src ip/port - to different dest. In case of tcp it acts 
like symmetric nat - ie each syn packet even from same src ip/port cause 
src port  mangling. What i need is to make it act like symmetric for udp 
too. So i just looked throught udp/tcp specific files 
(conntrack_proto_udp, nat_proto_udp and relative tcp ) and didnt find 
anything that makes it work different for tcp and udp. Tests revealed 
that at first time (and after timeout) each udp packets  (even from same 
src port/ip but to diff dest ) cause  new conntrack creation. But when 
it checkes before postrouting is tuple taken  - for same src/port 
somehow it says that no - so mangling doesnt occur. Can somebody give me 
a hint where to dig?

-- 

Sincerely,
Dmitry Gritsenko
DG@IPCB.net 
