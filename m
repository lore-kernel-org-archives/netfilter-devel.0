From: Kovacs Krisztian <piglet@sch.bme.hu>
Subject: Function pointers in conntrack structures
Date: Tue, 2 Sep 2003 15:16:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030902131616.GA3235@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

  I've found a weird looking function pointer in the connection tracking
system: the expectfn member of struct ip_conntrack_expect. AFAIK, this
function would be called by conntrack when a matching connection is found
for the registered expectation. However, I was unable to find any
conntrack helpers which use this functionality.

  My problem with this function pointer is that it cannot be replicated:
you cannot just send the function pointer over the wire, because on the
other nodes it may have completely different address. While there are
other pointers in the conntrack structures as well, all of them have some
kind of associated data which can be used as an ID. (For example: althoug=
h
helpers -- which are function pointers of some kind -- are associated wit=
h
conntrack entries, however, they have to be registered, and the conntrack
entry is associated with the registered helper structure instead of just =
the
callback function. This is very important, because these structures all
contain a "name" field, which can be used as an ID.

  So, the only problem point I've found is the expectfn field of struct
ip_conntrack_expect, for which I've no idea how that could be handled. Is
the possibility of having more than one kind of callback function for
expectation creation really so important? (If only one kind of function
would be usable by conntrack helpers, its address could be stored in
struct ip_conntrack_helper, and we didn't have the whole problem.)

  Any ideas?

--=20
 Kov=E1cs Kriszti=E1n (Hidden)
