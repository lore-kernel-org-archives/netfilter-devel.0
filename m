From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Modifying conntrack information on the fly & generating packets through
 hard_start_xmit
Date: Fri, 05 Mar 2004 10:14:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404836FD.2070107@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi!

The module I'm writing makes my computer crashes and I am now 
investigating the reasons. It seems to trigger an undesirable effect in 
some other parts of the netfilter code. Thus, I'd like to know if the 
following - that I'm doing - is possible: under certain conditions, my 
target module changes the conntrack information, for example it changes 
the tracked source address for another one.
Moreover, I sometimes generate packets using the hard_start_xmit 
function. Can packets generated in such a way go through any netfilter hook?

Thanks for any help,

         Emmanuel
