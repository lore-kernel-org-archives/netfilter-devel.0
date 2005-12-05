From: "swcims" <swcims@163.com>
Subject: Help:I want to set the same src and dest ports when doing SNAT
Date: Mon, 5 Dec 2005 11:04:35 +0800
Message-ID: <80.6491393179343$1133752049@news.gmane.org>
Reply-To: swcims@163.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

Hi All,
 
   I am working in netfilter on Linux2.4.17.Here is the top:
 
   PC1-------------------Linux NAT Router----------------------PC3
                          |    (192.168.1.1  200.0.0.1)                  (200.0.0.2)
   PC2-------------
 
   For example,PC1 and PC2 are in the LAN side(192.168.1.0/24),and they will be handle by SNAT of Linux router(192.168.1.1 and 200.0.0.1),PC3 is in the WAN side(200.0.0.2). 
   Now I  set PC1 and PC2 to setup IPSec tunnel to PC3.Yes,it is for multiple VPN passthru to the same VPN device in WAN side.You know,the src:dest port would be 500:500.But  unfortunetly,src:port of one the tunnel would be set to be 1:500 by Netfilter NAT feature.I know it is correct for NAT to do this modification.But some VPN device would only accept the packet of 500:500!
 So I want to make NAT to not change the src ports(500) of PC1 and PC2.Would anyone kindly provide information and advice?
 By the way, I can't use NAT-T to handle multiple VPN passthru. I know there would not be pefect to add conntrack helper and nat helper for isakmp and esp,but I have no choice.
 Any advice will be highly appreciated!
 
 Thanks a lot!
 
  Best Regards
 
        swcims
        2005-12-05
