From: Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: Re: Opinion on patch?
Date: Mon, 16 Sep 2002 21:04:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209162104.09871.bart.de.schuymer@pandora.be>
References: <638AA0336D7ED411928700D0B7B0D75B03053C91@aimail.aiinet.com> <20020916201518.Q3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
	"Eble, Dan" <DanE@aiinet.com>
In-Reply-To: <20020916201518.Q3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 16 September 2002 20:15, Harald Welte wrote:
> On Mon, Sep 16, 2002 at 01:22:00PM -0400, Eble, Dan wrote:
> > Do you have an opinion on my patch to allow indexing rules in a chain=
 by
> > negative numbers?  It has been several days, and so far no one has
> > responded--not even with "Oh, that's so stupid... who would ever want
> > that?"

I didn't look at the code closely, but I found it an interesting idea.=20
Ofcourse I was too lazy to mention this.
My personal opinion is that including this wouldn't be a sign of featurit=
is,=20
it's just a small extension of an available mechanism (although the patch=
 is=20
long). And it does add user flexibility.
Ofcouse, your triplicated mail with patch didn't encourage any reading...
Also, your mail seems to imply you changed 2 other things too: something =
about=20
the counters and something about the "prepend" flag. Maybe it's better no=
t to=20
do multiple different changes in one patch.

--=20
cheers,
Bart
