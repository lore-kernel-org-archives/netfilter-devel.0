From: "Song Wang" <wsong@ece.uci.edu>
Subject: Does iptables/netfilter support port triggering?
Date: Tue, 25 Jun 2002 15:04:56 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <LEEFKFFIDHJODEPLHAOGEEADCBAA.wsong@ece.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, folks,

Does iptables/netfilter support port triggering, which
can be found in Linksys home/vpn gateway? I guess port
triggering is a kind of dynamic port forwarding. It looks
like iptables can only specify static port forwarding, for
example, you must specify a specific IP address, while
port triggering can dynamically remember the IP address on 
the private network that initiates the connection request.

Thanks.

-Song
