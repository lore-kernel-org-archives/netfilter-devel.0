From: Calum <calum.sep02@umtstrial.co.uk>
Subject: Session Initiation Protocol
Date: Thu, 5 Sep 2002 15:25:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209051525.44011.calum.sep02@umtstrial.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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

Hello all,

With SIP soon to be huge, especially with 3G phones, is there any work 
underway to make a sip_masq module, a la FTP, or IRC?

I work in a test lab where we deal with SIP, and would be willing to help out 
if testing were needed. (tcpdump captures, etc)

If iptables beat the other firewall solutions to it (I think CheckPoint NG 
supports it) , it would probably be contemplated for a lot of firewall 
installations. And that can only be a good thing :)

Here is the SIP RFC.
(I cursed them when I found out that it didn't work through NAT. Although, 
with IPv6, we might not need it as much)
http://www.ietf.org/rfc/rfc2543.txt


Keep up the good work anyway.

Calum
