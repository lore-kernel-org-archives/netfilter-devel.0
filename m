From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH 2.4.x][RFC] enlarge struct ipt_log_info prefix to 62
	bytes
Date: Thu, 23 Dec 2004 02:09:05 +0100
Message-ID: <20041223010905.GC2484@eychenne.org>
References: <41C6BDC7.8060507@tac.ch> <41C95EC5.6090803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41C95EC5.6090803@trash.net>
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

On Wed, Dec 22, 2004 at 12:47:17PM +0100, Patrick McHardy wrote:

> Roberto Nibali wrote:

> >Concerning netfilter there is one I think others might "benefit" from =
as=20
> >well. Here's the patch we're using to enlarge the prefix member of the=
=20
> >struct ipt_log_info structure in ipt_LOG.h:
> >
> > struct ipt_log_info {
> >        unsigned char level;
> >        unsigned char logflags;
> >-       char prefix[30];
> >+       char prefix[62];
> > };

> This breaks binary compatibility, so we can't put it in.
> Otherwise I'd agree, 30 byte is kind of small. Maybe it
> will be possible with Rusty's and Pablo's work to extend
> structures without breaking compatibility.

BTW, we really should provide a /proc entry which would give the maximum
length of this LOG prefix.  And while we are at it, another one for
chainname length.  Can somebody think of another useful value which
would be worth publishing?
That will help third party applications a lot, so they can be aware
of how many chars they can use (these values can be changed
at compile time anyhow) and take advantage of it.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
