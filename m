From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 17:56:17 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088598377.27704.5.camel@vijay>
References: <20040630113602.963604C052@spy10.spymac.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: immidi@spymac.com
In-Reply-To: <20040630113602.963604C052@spy10.spymac.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

If A and B send packets to a server, say google.com:80 using the local
port 10000, when the pkts get SNATed on C, the source ports would be
different from 10000 (21000 and 32000 for example) and when google.com
sends back the packets to those new port numbers, conntrack would change
the dst-port numbers to 10000 along with the dst-ip address.

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies. 

On Wed, 2004-06-30 at 17:06, Kiran Kumar Immidi wrote:
> Hi,
>   When packets are being masqueraded from multiple machines through a NAT box,
> how would the response be identified as part of a particular connection. So, if
> we have (identical, as regards port numbers and dest ip address) packets from A
> and B snatted at C, how is the reply (to C) identified as belonging to either A
> or B? There does not seem to be any information in the packet to distinguish it.
> Regards,
> Kiran Kumar Immidi
> 
> ---- Cool Things Happen When Mac Users Meet! Join the community in Boston this July: www.macworldexpo.com
> 
> 
