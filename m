From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 11:18:29 +0200
Message-ID: <42C26765.2060304@tac.ch>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: daniel@benzedrine.cx, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
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

> Good catch: not required so I removed the dependency from the info
> file in svn.

Verified. Another thing is the link to Guido's paper. For me this is not =
working
anymore. So instead of linking the dead (if in fact it's dead) link:

    http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz

You could do following:

a. Put a mirror link into the document, e.g:

     http://www.madison-gurkha.com/publications/tcp_filtering/tcp_filteri=
ng.ps

b. Download the PS or PDF version of the paper and put it onto the Docume=
ntation
   section under "Various other docs", ITIM:

     http://www.netfilter.org/documentation/index.html#documentation-othe=
r

This also concerns the patch IMHO, so option b is maybe preferred.

> The last update sent to 2.6 kernel inclusion created the major differen=
ce
> between the two flavours. Now they are in sync and the most important
> fixes are in no particular order

Awesome, thanks. For the record, we're talking about the following change=
s:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patch=
lets/tcp-window-tracking/linux-2.4.patch?rev=3D4073&r1=3D4018&r2=3D4073

> - Article on which the code is based falsely
>   assumed that packets must fit completely into
>   the window: packets must at least overlap, logic fixed
> - Reopening connections now done properly
> - We handle ACK packets sent by server to late resent SYNs too
> - Arbitrary RST segments could cause connection
>   teardown, fixed.

Daniel, I hope you don't mind that I've cc'd you out of the blue sky rega=
rding
this issue. However, I'd like you, if possible, to comment on the possibl=
e
semantic differences between the window tracking implementation in OpenBS=
D pf
(also based on the Guido paper) and the current netfilter one. The releva=
nt
patch on the netfilter part can be found at:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patch=
lets/tcp-window-tracking/linux-2.4.patch?rev=3D4073&view=3Dmarkup

It would be nice to have a second opinion regarding the tcp state transit=
ions,
the SACK handling and the tcp_in_window() function, which is most critica=
l.
We're probably talking about this gem, among others:

http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/sys/net/pf.c?rev=3D1=
.493&content-type=3Dtext/plain

If it's not possible, drop me a private email and we'll meet somewhere in=
 Z=FCrich
in a bar along the Limmat for a beer to discuss this ;).

Best Regards,
Roberto Nibali, ratz
--=20
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
