From: "Eduard Calvo (B-teljpa) EXP JAN 03" <ecalvo@mat.upc.es>
Subject: Forced SNAT in PREROUTING
Date: Fri, 29 Nov 2002 18:25:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1038590746.3de7a31a50736@wmail-mat.upc.es>
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

 
  Hi gurus, 
 
  I'm a newbie iptables developer, so I'm reading all the iptables related 
stuff I can find. I have experience as an iptables user but now that I have to 
modify the code I feel very overcomed by the situation. 
 
  All I have to do is to allow the target SNAT to be called in the PREROUTING 
chain. Could someone guide me through the solution af this problem? I don't 
need any additional performance that translate the source IP address of the 
packets before routing. 
 
  Thanks in advanced. 
  Bye, 
 
                                    Eduard Calvo. 
 
 

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
