From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 20 Jan 2004 00:15:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040119231501.GB1142@eychenne.org>
References: <20040118132044.GA14663@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0401181806250.29966-400000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Julian Anastasov <ja@ssi.bg>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401181806250.29966-400000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 18, 2004 at 06:16:50PM +0100, Henrik Nordstrom wrote:

> On Sun, 18 Jan 2004, Harald Welte wrote:

> > yup. Please submit your changes against pom-ng (and patch-o-matic if you
> > want, but as of now I don't think we'll see another pom-old release).

> Attached you find 

> iptables userspace patch
> - manpage additions

Well... you were faster than me on this one.

> > well, we could do some semi-automated mechanism, like splitting it up in
> > one file per extension, and then concatenate the whole manpage from
> > those snippets depending on PF_EXT_LIBS / PF6_EXT_LIBS during the
> > iptables userspace make process.

> Good idea. Should be pretty trivial except for the sorting (may need to
> fight a little with locale)

Anyway, ideally, there should be only two descriptions of the
functionnality of each targets: a short one (as the one included in
iptables userspace modules, available through --help), and a longer one,
describing it exhaustively.
The manpage (and why not a more complete document like a howto, or
even a web page describing netfilter modules) should of course be generated
from the second (longest) one.
So there shouldn't be any need to include too much formatting "tags" in
the original text (describing the module functionnalites), and those should
be turned into the adequate tags if needed (for target languages like
XML, HTML...).

Now, several thoughts:

1) AFA the manpage is concerned, everyone seems to agree that p-o-m
  modules descriptions should not be included into the mainstream manpage.
  I agree with that.

2) p-o-m modules regularly tend to be included into mainstream
  kernels, and each new netfilter module description should then
  state that it is only valid as for a certain kernel version (because
  otherwise it would confuse people using older kernels).
  Even if this kind of information will tend to be more annoying over
  time, we can now raise the question of using the fact that
  "the iptables manpage will now be generated dynamically" in order to 
  generate the manpage according to the currently available netfilter
  modules.
3) However, I think it would be a bad idea to have the iptables manpage
  depend on what is currently installed at the time of its generation:
  this would introduce incompatibilities between manpages over
  different hosts, and people are not used to that (at least for
  manpages).
  Moreover, a kernel upgrade would require that the manpage gets
  rebuilded, which is impossible to ensure.
4) Yet, it would be interesting for people to have a way to know
  exactly which modules are currently usable on the system they have
  (and we have one on recent kernels, with /proc/*/*_{matches,targets}
  listings), and _how_ to use it
5) If we agree that the last point should be made possible, there
  should still be a way to know what is sure (coming from mainstream),
  and what is less (coming from p-o-m)

6) So should these descriptions be included in a separate "p-o-m
  extensions" manpage? It doubt it should.
  Why? The previous thoughts lead me to the conclusion they should
  not be contained in a manpage (I hardly believe that I should
  say that as the iptables manpage author ;-). And that's because
  manpages, static by essence (even if generated once) are not the
  place where ever changing things as netfilter modules (changing
  with kernels, and with a cvs p-o-m) should lie down.

That is why I'd rather limit the iptables manpage to pure iptables
syntax, and let a program display matches/target use according to the
user's choices:
- mainstream and/or coming from p-o-m
- usable on the current system and/or existing (even if not installed)

Please note that nothing would prevent from generating a summary document
(taking the form of a manpage or other) with all the matches/targets.

What should be done in that sense:
- Ensuring that module description is accurate after a kernel upgrade
  (possibly modified with p-o-m) (point 3.) would require that
  full descriptions are stored somewhere on the filesystem.
- Knowing which module is available where (points 2. and 5.) probably
  requires versioning of module descriptions (if not module version at
  all).
- Knowing if modules come from mainstream or p-o-m (point 5.) would
  require to include in binary modules the "comes from mainline or
  p-o-m" information. We could even think of more fine-tuned
  information bits, telling if module is considered stable or not
  (even if coming from patch-o-matic, submitted p-o-m modules can be
  considered stable, right?... and extra is more unstable than base,
  isn't it?)
- Writing the program itself (in Perl, probably).

Any comments?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
