From: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
Subject: segfault when linking with libiptables
Date: Thu, 04 Mar 2004 11:09:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40470052.8050004@fokus.fraunhofer.de>
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


hi,

I have the following problem when linking an user program with libiptables. the program may be as 
simple as the following:

#include <iptables.h>
#include <iptables_common.h>
#include <libiptc/libiptc.h>

int main(void) {
	find_match("dscp", LOAD_MUST_SUCCEED);
	return 0;
}

I compiled it with:

cc -c -O2 -ggdb -Wall -Wunused myprog.c
cc -O2 -ggdb -Wall -Wunused -export-dynamic -o myprog myprog.o -liptables -liptc -ldl

(Makefile attached)

when trying to load the dscp match extension, dlopen (which is invoked by find_match) segfaults. 
here is a transcript from gdb:

[...]
Reading symbols from /lib/tls/libdl.so.2...done.
Loaded symbols for /lib/tls/libdl.so.2
Reading symbols from /lib/tls/libc.so.6...done.
Loaded symbols for /lib/tls/libc.so.6
Reading symbols from /lib/ld-linux.so.2...done.
Loaded symbols for /lib/ld-linux.so.2
Reading symbols from /usr/local/lib/iptables/libipt_dscp.so...done.
Loaded symbols for /usr/local/lib/iptables/libipt_dscp.so
#0  0x400a0034 in strcmp () from /lib/tls/libc.so.6

does anybody have an idea which the cause could be? I am using gcc version 3.3.3 (Debian) and 
iptables-dev unstable. any help would be greatly appreciated.

cheers,
John.


========== Makefile ==========

all: myprog

CFLAGS:=-O2 -ggdb -Wall -Wunused

LDFLAGS      = -export-dynamic
LDLIBS       = -liptc -ldl

%.o : %.c
	$(CC) -c $(CFLAGS) $<


myprog: myprog.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm myprog.o myprog
