From: "Eduard Calvo (B-teljpa) EXP JAN 03" <ecalvo@mat.upc.es>
Subject: Problems with un-masqueraded packets
Date: Thu, 12 Dec 2002 18:29:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039714182.3df8c78629632@wmail-mat.upc.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 
  Hi gurus! 
 
  I have made a ip queue handler wich is capable to do SNAT before routing 
with the forwarded packets. In POSTROUTING, I do MASQUERADING over the nat'ed 
addresses. Could someone tell me the way the un-masked paquets traverse the 
netfilter hooks and when their source addres is changed? My box is doing 
something strange because it does not replace the source address with the 
address the packet has when it was masqued ( I mean, the address I put by 
force ); it replace the address with the ORIGINAL address the packet has ( 
before I changed it). This surprise me a lot. I want to do a tracking of the 
packet through my box, but I do not understant the way it goes. 
 
  Do you have any idea? 
  Thanks in advanced. 
 
                                        Eduard. 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
