From: Oumer Teyeb <oumer@cpk.auc.dk>
Subject: Pthreads and libipq , order of binding??
Date: Fri, 23 May 2003 18:18:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECE49E2.8070906@cpk.auc.dk>
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

Hi,
I have a libipq program that compiles perfectly with this

gcc -g -Wall -Wunused -DNETFILTER_VERSION=\"1.2.7\" -rdynamic -o test 
test.c /usr/local/lib/iptables.o /usr/local/lib/libiptc.a -ldl -lipq

and I wanted to put multithreading features on it and in my system I run 
pthread programs as

gcc  -D_POSIX_C_SOURCE=199056 -D_REENTRANT -ansi -lpthread -o 
test_thread test_thread.c

so I put some pthread functionality in my original pthread program and 
tried to compile with the following

gcc -g -Wall -Wunused -DNETFILTER_VERSION=\"1.2.7\" 
-D_POSIX_C_SOURCE=199056 -D_REENTRANT -ansi -rdynamic -o test test.c 
/usr/local/lib/iptables.o /usr/local/lib/libiptc.a -ldl -lipq -lpthread

but this time I get the error:

 >In file included from /usr/local/include/libipq.h:37
 >from test.c: 2:
 >/usr/include/linux/netfilter_ipv4/ip_queue.h:27: 'IFNAMSIZ' undeclared 
here (not a function)
 >/usr/include/linux/netfilter_ipv4/ip_queue.h:28: 'IFNAMSIZ' undeclared 
here (not a function)
 >/usr/include/linux/netfilter_ipv4/ip_queue.h:35: confused by earlier 
errors, bailing out

I think the problem is with some order of library binding, but I 
couldn't figure it (I tried to link one library before the other and the 
like).
What is wrong?
