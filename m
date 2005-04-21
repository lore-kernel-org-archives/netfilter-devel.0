From: "Alex" <alex_oz@gmx.net>
Subject: CLUSTERIP failover daemon?
Date: Thu, 21 Apr 2005 11:35:33 +0200
Message-ID: <000001c54655$7799a690$aa28abc1@Vagabond>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi all,

 

Is there any daemon which supports failover within CLUSTERIP-nodes?

Example:

 

*We have 4 Nodes running CLUSTERIP 10.0.0.1.

 

*Node 3 dies.

 

*Daemon executes on node 2:

echo "+3" > /cat/proc/ipt_CLUSTERIP/10.0.0.1

 

if node 3 failed. I see some problems doing this with scripts e.g. using
heartbeat.

 

Best regards.

 
