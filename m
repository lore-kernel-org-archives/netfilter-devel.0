From: "Retesh Chadha" <retesh.chadha@gmail.com>
Subject: query regarding hashlimit using ipset src,dst tuple
Date: Fri, 13 Oct 2006 12:20:22 +0530
Message-ID: <b322db070610122350j97a9f05nb5f30dfabdba4838@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi
I have a requirement as follows -

Say there are 2 source IPs - src1 and src2, and 2 destination IP - dst1, dst2.
I need to limit src1->dst1 as well as src2-dst2 communication but want
unlimited src2->dst1 communication.
I have a ipset KNOWN, which contains src1, src2, dst1, dst2

Now i write a rule as follows -
iptables -A INPUT_CHAIN --match hashlimit --hashlimit 1000/s
--hashlimit-mode srcipdstip --hashlimit-name foo -m set --set KNOWN
src,dst -j ACCEPT

But this will limit the src2->dst1 communication as well, which I dont want.

Is there a way to add ip1,ip2 as a tuple in a ipset the way we can do
for ip1%port?
Is there a mode which can help me do this, using a single iptable rule as above?
Is there a way to specify multiple ipsets in 1 iptable rule?

Thanks & Regards
Retesh Chadha
