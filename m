From: "=?GB2312?Q?=D6=A3=B4=AB=B2=A8?=" <zhengcb@netpower.com.cn>
Subject: the solution to synflood on netfilter
Date: Thu, 25 Dec 2003 18:11:38 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312251800109.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Check Point has two implementations on preventing synflood.  

One is to intercepts the syn packets between the client and the server. The firewall
sends a syn/ack packet to the client on behalf of the server when it receives a syn
packet. If the firewall received the Ack from the client,it will start another 3-way
handshake with the server. If not, the connection will be timeout on the firewall, 
without influncing on the server.

The other way is the firewall forward all the syn packets to the server. After get the
syn/ack from the server, the firewall sends a ack to the server on behalf of the client,
so that the connection on the server is removed from the half-opened queue immediately.
The if the ack from the client is received, the connection on the firewall is validated.
If not, the connection is timeout. And firewall sends a rst to the server.
	
I think it is possible to implement some methods similar to that on Checkpoint
in netfilter. Then synflood could be prevented with a netfilter firewall.

Any idea on that? thanks.
	
regards,
Jack Zheng
zhengcb@netpower.com.cn
