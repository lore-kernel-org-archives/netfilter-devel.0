From: Null Device <nulldevice83@yahoo.com>
Subject: seeking help on pom and other issues
Date: Mon, 3 May 2004 13:24:00 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040503202400.1496.qmail@web41906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi list,

i tried using pom.
already have linux source, using 2.4.22-10mdk,
downloaded iptables and pom-ng.

then after giving proper paths i ran ./runme from the
directory where i extracted
patch-o-matic-ng-20040302.tar.bz2 as root.

i want to install n use connlimit.
i found it in netfilter\extensions as well as pom-ng
dir
when i run ./runme base 
and when i press y for connlimit
i get an error
it states "newfile: 2 files in our way, unable to
apply"
i am unable to get this. any help in this regard wud b
invaluable.

Moreover for my modules which i am working on to learn
netfilter and iptables. userspace program sets the
parameters for the kernel module to work. in userspace
code i first bzero a srtuct, fill it with port values
whic i htons() brfore setting after setting required
values . when used with ports 20 and 22 it turns the
values into 5120 and 5632 (all in %d format)
respective which i am sure are wrong and shuld have
been sonething like 0020 or 0022. where i am
slipping??.

as i have learned that for skbuff transport header
(TCP/UDP/ICMP) do not exactly point to transport layer
headers as supposed to b . as per this pharck article 
" One should note that  the transport  header and
network header may very well point to the same 
location in memory.  This
is  the  case for TCP packets where  h  and  nh  are
both  considered  as
pointers  to IP header structures.  This means  that
attempting  to get a
value from h->th thinking it's pointing to the TCP
header will  result in
false results because h->th will actually be pointing
to the  IP  header,
just like nh->iph."
is it case with ICMP and UDP too?

any help in these matters wud b highly appriciated.

thx 


	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
