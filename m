From: "Konrad D." <darnok@post.pl>
Subject: manual connection adding to ip_conntrack hash table
Date: Fri, 16 Jan 2004 15:33:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <14603099.20040116153336@post.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
I'm in the course of writing my thesis about connection tracking in netfilter,
it's sad but I need help. So I'm asking for help you, the netfilter developers.
Topic of my thesis is High Availability Firewall.
We have two PC computers connected together. One computer act as
firewall. The second one is "just in case" the first one broke down.
If that happend the second one must take place of the first one and
get informaction about all connections that was established.

AFAIK I need to get connections from /proc/net/ip_conntrack on 1st computer
and then put them in the same place on 2nd one. My question i how I
can do that? Can I add new connection to ip_conntrack hash table by calling
some function(s)? I'm not well programer so please dont be mad on me ;).
I was googling and searching linux source code for some clue, and I'm
pretty sure that I need to modify ip_conntrack hash table but I don't
know how. So please help.

Best regadrs
