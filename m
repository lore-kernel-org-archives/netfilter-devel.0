From: Wojciech 'Sas' =?iso-8859-2?Q?Ci=EAciwa?= <cieciwa@dzp.ntt.com.pl>
Subject: [report] H323 failed.
Date: Tue, 05 Apr 2005 13:26:13 +0200
Message-ID: <1112700374.26189.1.camel@sas>
Mime-Version: 1.0
Content-Type: text/plain
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

  CC [M]  net/ipv4/netfilter/ip_conntrack_h323.o
net/ipv4/netfilter/ip_conntrack_h323.c: In function `h245_help':
net/ipv4/netfilter/ip_conntrack_h323.c:110: error: structure has no
member named `help'
net/ipv4/netfilter/ip_conntrack_h323.c:118: error: structure has no
member named `seq'
net/ipv4/netfilter/ip_conntrack_h323.c:128: warning: large integer
implicitly truncated to unsigned type
net/ipv4/netfilter/ip_conntrack_h323.c:133: error: too many arguments to
function `ip_conntrack_expect_related'
net/ipv4/netfilter/ip_conntrack_h323.c: At top level:
net/ipv4/netfilter/ip_conntrack_h323.c:148: error: unknown field `flags'
specified in initializer
net/ipv4/netfilter/ip_conntrack_h323.c:148: error:
`IP_CT_HELPER_F_REUSE_EXPECT' undeclared here (not in a
function)net/ipv4/netfilter/ip_conntrack_h323.c:148: error: initializer
element is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:148: error: (near initialization
for `h245.me')
net/ipv4/netfilter/ip_conntrack_h323.c:151: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:151: error: (near initialization
for `h245.tuple.dst')
net/ipv4/netfilter/ip_conntrack_h323.c:151: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:151: error: (near initialization
for `h245.tuple')
net/ipv4/netfilter/ip_conntrack_h323.c:152: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:152: error: (near initialization
for `h245.mask.src.u')
net/ipv4/netfilter/ip_conntrack_h323.c:152: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:152: error: (near initialization
for `h245.mask.src')
net/ipv4/netfilter/ip_conntrack_h323.c:153: warning: large integer
implicitly truncated to unsigned type
net/ipv4/netfilter/ip_conntrack_h323.c:153: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:153: error: (near initialization
for `h245.mask.dst')
net/ipv4/netfilter/ip_conntrack_h323.c:153: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:153: error: (near initialization
for `h245.mask')
net/ipv4/netfilter/ip_conntrack_h323.c:155: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ip_conntrack_h323.c: In function `h225_help':
net/ipv4/netfilter/ip_conntrack_h323.c:243: error: structure has no
member named `help'
net/ipv4/netfilter/ip_conntrack_h323.c:251: error: structure has no
member named `seq'
net/ipv4/netfilter/ip_conntrack_h323.c:261: warning: large integer
implicitly truncated to unsigned type
net/ipv4/netfilter/ip_conntrack_h323.c:263: warning: assignment from
incompatible pointer type
net/ipv4/netfilter/ip_conntrack_h323.c:266: error: too many arguments to
function `ip_conntrack_expect_related'
net/ipv4/netfilter/ip_conntrack_h323.c: At top level:
net/ipv4/netfilter/ip_conntrack_h323.c:301: error: unknown field `flags'
specified in initializer
net/ipv4/netfilter/ip_conntrack_h323.c:301: error:
`IP_CT_HELPER_F_REUSE_EXPECT' undeclared here (not in a
function)net/ipv4/netfilter/ip_conntrack_h323.c:301: error: initializer
element is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:301: error: (near initialization
for `h225.me')
net/ipv4/netfilter/ip_conntrack_h323.c:305: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:305: error: (near initialization
for `h225.tuple.src.u')
net/ipv4/netfilter/ip_conntrack_h323.c:305: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:305: error: (near initialization
for `h225.tuple.src')
net/ipv4/netfilter/ip_conntrack_h323.c:306: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:306: error: (near initialization
for `h225.tuple.dst')
net/ipv4/netfilter/ip_conntrack_h323.c:306: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:306: error: (near initialization
for `h225.tuple')
net/ipv4/netfilter/ip_conntrack_h323.c:307: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:307: error: (near initialization
for `h225.mask.src.u')
net/ipv4/netfilter/ip_conntrack_h323.c:307: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:307: error: (near initialization
for `h225.mask.src')
net/ipv4/netfilter/ip_conntrack_h323.c:308: warning: large integer
implicitly truncated to unsigned type
net/ipv4/netfilter/ip_conntrack_h323.c:308: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:308: error: (near initialization
for `h225.mask.dst')
net/ipv4/netfilter/ip_conntrack_h323.c:308: error: initializer element
is not constant
net/ipv4/netfilter/ip_conntrack_h323.c:308: error: (near initialization
for `h225.mask')
net/ipv4/netfilter/ip_conntrack_h323.c:310: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ip_conntrack_h323.c:325: warning: type defaults to
`int' in declaration of `PROVIDES_CONNTRACK'
net/ipv4/netfilter/ip_conntrack_h323.c:325: warning: parameter names
(without types) in function declaration
net/ipv4/netfilter/ip_conntrack_h323.c:325: warning: data definition has
no type or storage class
net/ipv4/netfilter/ip_conntrack_h323.c:326: warning: type defaults to
`int' in declaration of `PROVIDES_CONNTRACK'
net/ipv4/netfilter/ip_conntrack_h323.c:326: warning: parameter names
(without types) in function declaration
net/ipv4/netfilter/ip_conntrack_h323.c:326: warning: data definition has
no type or storage class
make[1]: *** [net/ipv4/netfilter/ip_conntrack_h323.o] Error 1
make: *** [_module_net/ipv4/netfilter] Error 2

-- 
{Wojciech 'Sas' Cieciwa - Member of PLD Team                     }
{e-mail: cieciwa@dzp.ntt.com.pl, http://www.republika.pl/cieciwa }
