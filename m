From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RFC: conntrack hash function comparison
Date: Mon, 20 Jan 2003 11:26:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Using Patrick's cttest utility I have finished the testing of different
hash functions for connection tracking:

http://www.kfki.hu/~kadlec/sw/netfilter/ct/

The very brief summary of the pages:

- original hash function: really bad for hash sizes of power of two
  and it can be bad for odd hash sizes as well.

  We truly need a better hash function.

- Guilmette and Pearson hashes: they are good but too slow
- crc32 hashes (crc32, crc32_2x6, crc32_bof): they are also good, but
  slow
- abcd hashes (abcd, abcdx, abcdef, abcd_xor): the fastest and
  at the same time remarkably good hash functions!
- rt hashes (rt, rt_ab, rt_ab2, rt_new)): the rt hashes are also fast,
  but not so good hashes
- jenkins (jenkins, jenkins2, jenkins2b) and buzhash hashes: they are
  very good hash functions, but alas not fast enough.

My short conclusion is that we have to adopt the abcd or abcdx hash
as the conntrack hash function.

Please look trough the web pages and comment it.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
