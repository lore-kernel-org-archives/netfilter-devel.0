From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Some questions about using heavy iptables rules in a Linux box
 ....
Date: Wed, 10 May 2006 01:59:11 +0200
Message-ID: <44612CCF.5030400@gmx.net>
References: <4460B502.4080903@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hbchen <hbchen@lanl.gov>
In-Reply-To: <4460B502.4080903@lanl.gov>
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

hbchen wrote:
> Hi,
> I have some questions about using heavy iptables rules in a Linux box.
> 1. Has anyone done a comparison of latency and throughput on traffic
> through an
>    Linux node with and without IPtables (using lots of filtering rules)?
> 2. How much CPU time is spending on iptables (heavy filtering rules)?
> 3. Any significant impact (latency and throughput) on 10G ethernet link?

May I suggest using nf-hipac? It's available at http://www.hipac.org/ .
Especially for thousands of rules, it should be faster than iptables.


Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
