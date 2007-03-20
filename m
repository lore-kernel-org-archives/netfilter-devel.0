From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:07:47 +0100
Message-ID: <45FFF8C3.9050606@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi,


   I'm wondering if bloom filters could not improve performance of the
conntracker. For a quick overwiew of bloom filters see
http://www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/BloomFilterSurvey.pdf

In a few words, a bloom filter is a data structure which represents
concisely a set. When you have a set, you can decide very quickly if an
element belongs to it.

I was then wondering if we could not get rid of these two
list_for_each_entry in the __nf_conntrack_confirm by using the bloom
filters.

You can use it as a key for a hash table as well. And therefore we may
use them at a later stage for the hash table as well. But let's see
first if you're interested by the previous idea ;)

What do you think?


Regards,
Sebastien Tandel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF//jDw76McB8jGxkRClszAJ0Zp2Jw1ctmldL3EX4NPhNchz9OZQCgluPh
i8edz1Zv/JuBUso/mqTx4EQ=
=xkDc
-----END PGP SIGNATURE-----
