From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 2 Mar 2007 09:46:20 +0100
Message-ID: <200703020946.20765.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello together,

the ipt_owner match of 2.6.20 is not allowed to be used in the INPUT chain. 

The .hooks entry looks like this:
.hooks          = (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING)

Back in the days it was allowed to be used in the INPUT chain for TCP/UDP.
I've searched the mailinglist archive but couldn't find anything useful.
What's the reason behind the change?

Cheers,
Thomas
