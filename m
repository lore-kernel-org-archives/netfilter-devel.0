From: Diego Cabrero <diego.cabrero@e-attico.net>
Subject: ffff:,  imq or nothing?
Date: Tue, 13 Dec 2005 10:12:08 +0100
Message-ID: <439E9068.8020204@e-attico.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
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

Hi all:

At first, i must control the whole inbound traffic and particulary VoIP packets coming from my ISP. 
As i can see from other people scripts, probably the easiest way to get it done is by  using ffff: with the ingress table, like this:

tc qdisc add dev $DEV handle ffff: ingress

tc filter add dev $DEV parent 
ffff: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 
${DOWNLINK}kbit burst 10k drop flowid :1

But it makes me thing VoIP packets will be dropped and its real time feature won't work. right?

Might i do this without installing imq?(which is supposed to be risky if some patch does not work)
