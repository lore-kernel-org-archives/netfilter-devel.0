From: Paul P Komkoff Jr <i@stingr.net>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Thu, 20 Jun 2002 22:15:21 +0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020620181521.GP23720@stingr.net>
References: <20020620145619.GA1404@mail.nontoxic.org> <200206201736.11210.hno@marasystems.com> <20020620162341.GB2331@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020620162341.GB2331@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

Replying to Joakim Axelsson:
> May instead propose to take the name "action". And keep the -j TARGET name.
> Meaning:
> 
> 1. IP match data
> 2. A list of matches
> 3. (If 1 and 2 all matches) A list of actions. (LOG, MARK, CONNMARK).
> 4. An optional target. Can be this virtual JUMP.
> 
> Example:
> 
> iptables -A INPUT -s 10.11.12.13 \
>  -m limit --limit 5/s   -m unclean --unlean-option \
>  -a Log --log-prefix    -a Mark --mark-option \
>  -j JUMP --jump-chain my_own_chain

too complex, but in-line with current design

so what do you think about compile&exec idea existed for a long time in form
of bpf/lpf and re-implemented for firewall packet filtering by ipfw creator
for freebsd-CURRENT ?

for one who don't read it. the basic, the IDEA is to take a complex match
and compile it into set of smaller matches taken in some order, with
jump-like instructions, linking our "matchset" by jumps forward and backward
to (finally) "exit"

replace matches with "transformations" or "plugin function calls",
respectively

(yes, it way too much from current design, heh, that's why I'm asking "what
do you think")

- -- 
Paul P 'Stingray' Komkoff 'Greatest' Jr /// (icq)23200764 /// (http)stingr.net
  When you're invisible, the only one really watching you is you (my keychain)
-----BEGIN PGP SIGNATURE-----

iEYEAREDAAYFAj0SG7cACgkQyMW8naS07KSQBACfdZDE0A/qfq3zbTY0uDRP/aoY
iIkAn0cRlNbHjSy0JQjIYD9PqGq87PYC
=Yx9b
-----END PGP SIGNATURE-----
