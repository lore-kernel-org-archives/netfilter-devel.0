From: Mikkel Christiansen <mixxel@cs.auc.dk>
Subject: question: hook/unhook
Date: Thu, 01 Jul 2004 14:31:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40E40405.4030905@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

We're working with an efficient packet filter
(see http://www.cs.auc.dk/~mixxel/cf). 

In the implementation we would like to block
all arriving packets while moving from one filter
to another. I.e. something like:

block_all_packets();
nf_unregister_hook(some_nf_hook_ops_struct);
nf_register_hook(some_other_nf_hook_ops_struct);
unblock_all_packets();

Does netfilter provide functions for doing this or can anyone
recommend a proper way to do this?

Cheers & thanks
    Mikkel
