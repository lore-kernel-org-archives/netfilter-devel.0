From: Haris Koutsouris <harisk@epmhs.gr>
Subject: netfilter vs iptables naming confusion
Date: Mon, 08 Dec 2003 13:17:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD45DDC.9030901@epmhs.gr>
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

Dear All,

I am not a netfilter hacker but i need your insight, i hope you can help 
me out.
I am a co-author of an upcoming book concerning Honeynets. In this book 
we need to refer to the netfilter/iptables  functionality and we try to 
provide a 2 page introduction for the readers just to get them going.
One of the book reviewers felt we where missusing the term iptables and 
we should use netfilter instead. Since i value the reviewer's view but i 
also felt strong on my point i would be obliged if you can shed some 
light on this problem. Well i really don't intened to confuse any of our 
readers so i depend on you to make it clear.
Next follows my understanding on what netfilter and iptables are, Please 
comment.


<my understanding>
Netfilter is a set of hooks in the networking code of the linux kernel
  that allows another piece of code (kernel module) to register for 
access  to the packets that pass through these points. Several iptables 
kernel modules (e.g ip_tables, iptable_mangle,ipt_conntrack, ipt_LOG) 
implement
  the firewalling functionality and in addition the user space utility
  iptables is used as a user interface to the iptables functionality.

If I am correct, then the Netfilter code though its a great idea it
  shouldn't be that big percentage of the firewalling code. Thus, i fill
  that we can name the whole thing IPTables provided we add a footnote
  stating the existance of Netfilter and provide enough references for 
the user to explore the whole magic of netfilter/iptables.
</my understanding>

A final question are the kernel modules named iptables modules or 
netfilter modules?????

A raw grep in the archives of the netfilter users mailing list revealed 
the following:
grep "iptables modules" user-netfilter.mbox | wc -l
      84 references
grep "netfilter modules" user-netfilter.mbox | wc -l
      68 references

The same search on the developers list revealed:

"iptables modules" 37 references
"netfilter modules" 99 references


Thank you for your advice.

Yours

Haris Koutsouris
