From: Michael Schwendt <rh0209ms@arcor.de>
Subject: Re: rules inserted with bad interface name
Date: Sat, 23 Nov 2002 15:49:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021123154940.47cce4fb.rh0209ms@arcor.de>
References: <20021123001230.GA23841@ns>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021123001230.GA23841@ns>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Fri, 22 Nov 2002 19:12:30 -0500, Laurence J. Lane wrote:

> http://bugs.debian.org/170040
> 
> There appears to be an argument parsing bug in iptables, tested with
> version 1.2.7a. If -i or -o is used without a space between the
> interface and the option, iptables use the option as part of the
> interface name. For example:
> 
>   iptables -A INPUT -ifoo
> 
> That actually appends the rule with the inbound interface 
> literally named "-ifoo".

Well, first of all, it gives a warning:

  Warning: wierd character in interface -ifoo' (No aliases, :, ! or *).

I wouldn't say it is a parsing bug. According to the manual, it is a
syntax error and hence the user's mistake. The manual does not state
that you can omit the space(s) between option and argument.

If you were allowed to enter -ifoo, you would also want to enter
- -i!foo. But that would be an "event"

  # iptables -A test -i!foo
  bash: !foo: event not found

and therefore would need proper quotes

  # iptables -A test -i'!foo'    
  Warning: wierd character in interface -i!foo' (No aliases, :, ! or *).

and extra fixes in other parts of the iptables tools:

  # iptables-save | grep ^-
  -A test -i -i!foo 

Ooops! ;) Supporting both -i!foo and -i ! foo would make the parsing
unnecessarily complex and the syntax error-prone.

As I see it, iptables uses getopt to parse the command-line options.
When -i is found, getopt determines the next argument that is not an
option and makes it available as a string called "optarg". Getopt
recognizes the argument in both -i foo and -ifoo correctly as "foo".
The parser *could* work with that argument. However, in order to
support an optional '!' prefix argument, the current code accesses
the array of arguments using the option index called "optind". When
the '!' is found, the code simply assumes the next argument, which
is not an option, is the interface argument. It could not do that if
it were possible to merge option, '!' prefix and required argument.
That would require different parsing in some places in addition to
the current implementation. I don't think changing this would be
worth the effort. Stick to the syntax from the manual, and you don't
run into errors.

Of course, this is just my point of view.

Michael

- -- 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE935WE0iMVcrivHFQRAnRvAJ0YtJDboAjs1tqvwy9cijDBDSuXmACfajie
/YYldYS9TMj2D+KSIZWKL+Y=
=yhlm
-----END PGP SIGNATURE-----
