From: Arch Harris <netfilter02@jah.cs.jmu.edu>
Subject: /etc/sysconfig/iptables format
Date: Wed, 20 Nov 2002 00:21:57 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

I was rather surprised at being unable to find hardly any information on 
the format of the /etc/sysconfig/iptables file.  It seems everyone uses a 
three step approach: execute a bunch of iptables commands, store the
result by executing iptables->save, restore using iptables->restore.
It strikes me as being much easier to just write /etc/sysconfig/iptables
and let /etc/rc.d/init.d/iptables take care of the saving and restoring.

Whether my approach is easier or not, one should be able to find 
documentation that describes the format of the file used by iptables-save
and iptables-restore.  But I could not find that info in any of the HOWTOs 
or in any man pages in the distribution.

I realize the syntax fllows the iptables command arguments.  But there
are some differences.  Things like: *filter, COMMIT, etc.  I think
I have figured most of this stuff out, but a man page and/or HOWTO
chapter describing the file format sure would be nice.

Arch
+------------------------------------------------------+
| Dr. J. Archer Harris     MSC 4103, Computer Science  |
| netfilter02@jah.cs.jmu.edu James Madison University  |
| (540) 568 - 2774         Harrisonburg, VA 22807      |
+------------------------------------------------------+
