From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 02:19:58 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304240213430.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


	Hi all,

	I need to replace the current list-based netfilter code for 
something using hashtables. The reason is that I have hundreds of tables 
in a project, but set up times are killing me. I took a peek at the code 
and it looked easy to do, since the current list-based code already takes 
care of locking, that's a huge problem I don't have to care about.

	Is there something I should know abot? Any tips? Is this stupid?

	Thanks in advance,
	Andre
