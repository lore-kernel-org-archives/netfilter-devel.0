From: Fabio Spelta <spelta@linux.it>
Subject: Which version of libipq? (or: "How to compile "OSFPE" "?)
Date: 15 Feb 2003 11:06:05 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1045307166.1157.37.camel@vaniglia>
Mime-Version: 1.0
Content-Type: text/plain
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

...where OSFPE should be for "Operating System fingerprint evasion" ?

Hello All.

I got a fine (hopefully) source code of Rob Beck (which is impossible to
find or to mail for asking himself), from this link 
ftp://ftp.ssc.com/pub/lj/listings/issue89/4750.tgz
found in a Linux journal article. (Well, that article it is really not
SO more than the Fyodor one about fingerprinting with nmap, but this
does not matter). 
The tool should make appear "microsoft windows" if a scan that try to
fingerprint the OS is executed on the machine running "osfpe", no matter
which real OS is it running.

So, I got the source; and I downloaded the CVS of the userspace tools of
netfilter because it needed the "libipq" library.

Too bad, as an header of libipq itself says, the library is still in
development and the API too may change. Hm. (the article is of September
2001)
In fact, I got two errors, one was easy to fix, the other not:

# gcc -Inetfilter/userspace/include/libipq/ osfpe.c

fregabis.c: In function `Watch_Queue':
fregabis.c:479: too few arguments to function `ipq_create_handle'

So I changed the call
handle = ipq_create_handle(0);

to:

handle = ipq_create_handle(0,0);

Adding a COMPLETELY FAKE parameter! (oh, yes, what a lamer am I! :))

Then I tried to compile it by telling gcc to link the library too.
(too bad, when I compiled the library I do not got a .o file, but only
.3 and .a files. Oh, yes, what a lamer.. )

gcc -Inetfilter/userspace/include/libipq/ -lnetfilter/userspace/libipq/
osfpe.c : 

/usr/bin/ld: cannot find -lnetfilter/userspace/libipq/
collect2: ld returned 1 exit status


So, to put an end, what I'd like to know from you is:
Can you tell me if there is a more suitable version of libipq that I
should downgrade to, for having it to work?

Or, this one can be good but I'm a jerk and I cannot link a "simple"
library? In that case, what's the damn second argument of
ipq_create_handle() ?

Thank you very much!
Salutations, with lots of esteem.

-- 
  Fabio Spelta
  
   email:  spelta@linux.it
   jabber: febs@jabber.linux.it
   ecdl project: http://ecdllibre.sf.net
