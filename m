From: Swapnil Nagle <swapsn@rediffmail.com>
Subject: per-cpu table information
Date: Thu, 09 Sep 2004 15:47:02 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41402D9E.5050906@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi all,

Why is the table information (ipt_table_info to be specific) duplicated 
for each CPU in ipt_table?
Is it required so that new rules can be added simultanously while the 
existing rules are processed ?

Regards,
Swapnil.
