From: Henrik Ehlig Petersen <henrik.ehlig.petersen@ericsson.com>
Subject: ipv4options patch
Date: Fri, 28 Oct 2005 15:33:47 +0200
Message-ID: <436228BB.3050406@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I have applied the ipv4options patch to the iptables/netfilter
function, and have some questions:

How is the srr flag/register used in iptables? It is defined as a char,
but how are the bits used? An example in the code makes a binary AND
between the srr and a "boolean" (the is_strictroute). Is it because bit
0 in the srr register contains the relevant info? Or how should I
understand the example below:

else if ((info->options & IPT_IPV4OPTION_MATCH_LSRR) ==
IPT_IPV4OPTION_MATCH_LSRR) {
		if (!((opt->srr) & (!opt->is_strictroute)))
			return 0;
	}

Hope you can help me, thanks!!

-- 
BR
Henrik
