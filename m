From: Leonardo Henrique Machado <leoh@dcc.ufmg.br>
Subject: Question about procfs function
Date: Sun, 25 Jan 2004 19:23:18 -0200 (BRST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401251921480.2228-100000@truta.dcc.ufmg.br>
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


Where can I find a complete tutorial about procfs?

I need to print a whole table in a procfs file.
I have created the file but I cannot understand
one of it's functions:

proc = proc_net_create(procfs_name, 0, procfs_getinfo);

procfs_getinfo is a very confusing function! I would like
to save a linked list in a buffer and after that I'll print
it in the procfs buffer file.

I know that procfs_getinfo (or whatever name you gave it)
must return a integer representing the size of the buffer
that will store my table. Anyway, where can I find good
tutorials and examples about using this procfs buffer
function?

Is there a better place to ask about it?


//leoh
main(){int j=1234;char t[]=":@abcdefghijklmnopqrstuvwxyz.\n"
,*i = "iqgbgxmlvivuc\n:wwnfwsdoi"; char *strchr(char *,int);
while(*i){j+=strchr(t,*i++)-t;j%=sizeof t-1;putchar(t[j]);}}
