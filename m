From: Stephen Clark <Stephen.Clark@seclark.us>
Subject: DNS rebinding
Date: Tue, 07 Aug 2007 12:11:11 -0400
Message-ID: <46B8999F.3060202@seclark.us>
Reply-To: Stephen.Clark@seclark.us
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello List,

There is an article about DNS rebinding at the following site:
http://crypto.stanford.edu/dns/


"Circumvention-Resistant Firewalls. Firewalls can prevent
their own circumvention by forbidding external host
names from resolving to internal IP addresses, preventing
the attacker from naming the target server, either by filtering
packets [6] or by modifying their DNS resolver."

Can netfilter be setup to keep dns responses from pointing to internal addresses by filtering the packets? If so how would one go about setting that up.

Thanks,
Steve
-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)
