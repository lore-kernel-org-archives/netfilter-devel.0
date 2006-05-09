From: hbchen <hbchen@lanl.gov>
Subject: Some questions about using heavy iptables rules in a Linux box ....
Date: Tue, 09 May 2006 09:28:02 -0600
Message-ID: <4460B502.4080903@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,
I have some questions about using heavy iptables rules in a Linux box.
1. Has anyone done a comparison of latency and throughput on traffic 
through an
    Linux node with and without IPtables (using lots of filtering rules)?
2. How much CPU time is spending on iptables (heavy filtering rules)?
3. Any significant impact (latency and throughput) on 10G ethernet link?

Thanks.
HB Chen
hbchen@lanl.gov
