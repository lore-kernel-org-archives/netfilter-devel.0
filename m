From: Vinod Chandran <vinod_chandran@multitech.co.in>
Subject: Usage of CONNMARK
Date: Fri, 04 Feb 2005 13:43:57 +0530
Message-ID: <42032EC5.4090303@multitech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I am using the CONNMARK patch.
Inside conntrack_core, in case of special conditions, I have modified 
the mark value in the conntrack.

I then added the following rules in FORWARD chain.

iptables -t mangle -A FORWARD -m connmark --m mark 1 -j DROP

where the CONNMARK is set in case of the illegal packet.

However this CONNMARK value is getting effective only for the next 
packet and not for the same packet.

Is there some way by which, I can make the settings applicable to the 
same packet itself?

Thanks and Regards,
Vinod C
