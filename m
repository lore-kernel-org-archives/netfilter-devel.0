From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Question about TOS matching
Date: Sat, 13 Nov 2004 22:52:52 -0500
Message-ID: <4196D694.1050503@cookinglinux.org>
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

Hi there,

I just wondered why the accepted TOS values taken by libipt_tos.c are :

} TOS_values[] = {
   { IPTOS_LOWDELAY,    "Minimize-Delay" },
   { IPTOS_THROUGHPUT,  "Maximize-Throughput" },
   { IPTOS_RELIABILITY, "Maximize-Reliability" },
   { IPTOS_MINCOST,     "Minimize-Cost" },
   { IPTOS_NORMALSVC,   "Normal-Service" },
};

What if people wants to match other TOS ?
Is this only an user-friendly issue as they need to enter the value as 
decimal ?

Thanks answering that dumb question

Samuel
