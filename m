From: Jay Hester <jay.hester@khaletech.com>
Subject: c++ linking problems
Date: Wed, 12 Apr 2006 16:03:11 -0500
Message-ID: <443D6B0F.3050206@khaletech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,
     This is probably something easy that i'm overlooking, but how do 
you link in netfilter_queue in to a c++ program?

     I've lightly modified the code in 
libnetfilter_queue-<vers>/utils/nfqnl_test.c to build a test program. 
When I try to compile the program i'm getting lots of linking errors 
like this:

[jbhester@sidewinder src]$ make
 cd .. && /bin/sh /home/jbhester/projects/midevil/missing --run 
automake-1.9 --gnu  src/Makefile
 cd .. && /bin/sh ./config.status src/Makefile depfiles
config.status: creating src/Makefile
config.status: executing depfiles commands
g++  -g -O2   -o nfq_test  nfq_test.o  -lnetfilter_queue -lnfnetlink
nfq_test.o: In function 
`main':/home/jbhester/projects/midevil/src/nfq_test.cpp:41: undefined 
reference to `nfq_open()'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:47: undefined 
reference to `nfq_unbind_pf(nfq_handle*, unsigned short)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:52: undefined 
reference to `nfq_bind_pf(nfq_handle*, unsigned short)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:57: undefined 
reference to `nfq_create_queue(nfq_handle*, unsigned short, int 
(*)(nfq_q_handle*, nfgenmsg*, nfq_data*, void*), void*)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:63: undefined 
reference to `nfq_set_mode(nfq_q_handle*, unsigned char, unsigned int)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:68: undefined 
reference to `nfq_nfnlh(nfq_handle*)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:69: undefined 
reference to `nfnl_fd(nfnl_handle*)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:73: undefined 
reference to `nfq_handle_packet(nfq_handle*, char*, int)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:77: undefined 
reference to `nfq_destroy_queue(nfq_q_handle*)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:80: undefined 
reference to `nfq_close(nfq_handle*)'
nfq_test.o: In function 
`process':/home/jbhester/projects/midevil/src/nfq_test.cpp:19: undefined 
reference to `nfq_get_msg_packet_hdr(nfq_data*)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:24: undefined 
reference to `nfq_get_payload(nfq_data*, char**)'
:/home/jbhester/projects/midevil/src/nfq_test.cpp:28: undefined 
reference to `nfq_set_verdict(nfq_q_handle*, unsigned int, unsigned int, 
unsigned int, unsigned char*)'
collect2: ld returned 1 exit status
make: *** [nfq_test] Error 1


    I've tried lots of things like adding "nfq_test_LDADD = 
/usr/local/lib/libnetfilter_queue.[a|so]", and using the dynamic linking 
as a dso object, but nothing is working.

    Thanks ahead of time for the help.

Jay
