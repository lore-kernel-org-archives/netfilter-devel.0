From: dhobson@csa.concordia.ab.ca
Subject: iptables problems
Date: Fri, 18 Oct 2002 15:15:27 -0600 (MDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034975727.3db079ef4b83d@unclehenry.csa.concordia.ab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Using Linux Firewalls 2nd edition by Ziegler and iptables documentation on the
various web sites as a guide I developed a firewall for a small LAN.    To
enable the use of private addresses on the LAN I incorporated SNAT in the script.

One of the recommendation I found was to flush all existing tables and set the
various policies to DROP at the start of the script.  

To make a long story short if I use the following command "iptables -t -nat
--policy POSTROUTING DROP" in the script I cannot surf, if it's commented out I
can surf.  I have this line after I have enabled SNAT.  Should I have it before
the line?

All the examples I found show the enabling SNAT  before the DROP line. 

thanks
brock
