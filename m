From: alex <alex@bennee.com>
Subject: IP Connection Tracking - which connections?
Date: 16 Jun 2002 13:12:56 +0100
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024229576.13234.4.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter Development Mailing List <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm running a NAT'ed firewall on my gateway box and recently I've been
having problems with the connection chocking and I have been unable to
ssh onto the box to see what was going on. I think (as I've not got
loads of memory) its probably due to the maximum number of tracked
connections being exceeded (the logs show ip_conntrack droping new
conenction).

However I'm still unsure as to why I couldn't shell onto the box. After
all the ssh connection doesn't need to tracked as it terminates on that
box (and should't go through any of the -t nat tables). Or am I
misunderstanding the workings of conntrack?

Cheers,
 
-- 
Alex@Bennee.com
http://www.bennee.com/~alex/
