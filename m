From: Wojciech 'Sas' =?iso-8859-2?Q?Ci=EAciwa?= <cieciwa@dzp.ntt.com.pl>
Subject: connlimit error?
Date: Tue, 05 Apr 2005 16:07:52 +0200
Message-ID: <1112710072.30219.3.camel@sas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kraxel@bytesex.org
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

In connlimit module for 2.6.11 in line 74 is:
[..]
[74]                    found != NULL && ct = tuplehash_to_ctrack(found)
&&
[..]
in my kernel 2.6.11.6 with some patches it can't compile
return error:
router:~/rpm/BUILD/linux-2.6.11.6%make SUBDIRS=net/ipv4/netfilter
  CC [M]  net/ipv4/netfilter/ipt_connlimit.o
net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
net/ipv4/netfilter/ipt_connlimit.c:75: error: invalid lvalue in
assignment
make[1]: *** [net/ipv4/netfilter/ipt_connlimit.o] Error 1
make: *** [_module_net/ipv4/netfilter] Error 2

when I removed "ct = tuplehash_to_ctrack(found)"
like in linux-2.6 module all looks OK.

Can anyone looking on this ?

Thanx.
					Sas.
-- 
{Wojciech 'Sas' Cieciwa - Member of PLD Team                     }
{e-mail: cieciwa@dzp.ntt.com.pl, http://www.republika.pl/cieciwa }
