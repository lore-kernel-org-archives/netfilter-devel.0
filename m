From: John Lenton <john@vialibre.org.ar>
Subject: Re: splitting the libs
Date: Fri, 6 Sep 2002 16:09:57 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020906190957.GF663@vialibre.org.ar>
References: <20020902202834.GB29667@vialibre.org.ar> <20020905094453.GF1064@naboo.lincon.Uni-Koeln.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20020905094453.GF1064@naboo.lincon.Uni-Koeln.DE>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 05, 2002 at 11:44:53AM +0200, Harald Welte wrote:
> On Mon, Sep 02, 2002 at 05:28:35PM -0300, John Lenton wrote:
> > I compiled netfilter 1.2.6a against uclibc, and I found that
> > iptables, iptables-save and iptables-restore were all about the
> > same size, and while ~300k for the three of them was more or less
> > ok, 300k _each_ was out of the question. I looked a bit more and
> > found I could split all the functionality into .so files, and
> > have the same three binaries (plus these .sos) in the same size.
> >=20
> > Is there any reason this later config isn't done by default? or
> > at last enableable via the makefile?
>=20
> The reason is that nobody implemented it yet and send a non-intrusive
> patch :)
>=20
> So if you have done it, please contribute it!

I did it by hand; fixing the Makefile cleanly would be more time
than I currently have. Let me know if you won't be able to do it,
so I'll add it to my TODO :)

btw, s/300k/50k/ (got my numbers wrong)

Anyhow, if it's any use, what I did was make as usual, and then

    make libiptc/libip4tc.o
    ld -s -O2 -shared -soname=3Dlibip4tc.so.1.2.7 libiptc/libip4tc.o \\=20
        -o libip4tc.so.1.2.7
    ld -s -O2 -shared -soname=3Dlibiptables.so.1.2.7 iptables.o      \\
        -o libiptables.so.1.2.7
    for i in *.1.2.7; do ln -s $i ${i/1.2.7/}; done
    for i in iptables-standalone iptables-save iptables-restore; do
        cc -s -O2 -Wall -Wunused -I/usr/src/linux/include          \\
            -Iinclude/ -DIPTABLES_VERSION=3D\"1.2.7a\"               \\
            -DIPT_LIB_DIR=3D\"/usr/local/lib/iptables\" -rdynamic    \\
            -o ${i/-standalone/} $i.c -ldl -L. -liptables -lip4tc
    done

then i copied libip* into /lib/.

As I say, please let me know if I should do this myself (about
two months from now -- with luck) or if you will, or if it
totally gross (and why :).

--=20
John Lenton (john@vialibre.org.ar) -- Random fortune:
Cuanto m=E1s conozco a la gente m=E1s quiero a mi perro.
		-- Di=F3genes. (413-323 a.C.) Fil=F3sofo griego.=20
