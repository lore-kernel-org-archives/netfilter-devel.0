From: Patrick Schaaf <bof@bof.de>
Subject: Re: performance issues (nat / conntrack)
Date: Mon, 24 Jun 2002 09:13:25 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020624091325.S5183@oknodo.bof.de>
References: <20020623132739.12D52455E@lists.samba.org> <15638.42021.31206.821255@isis.cs3-inc.com> <20020624080618.Q5183@oknodo.bof.de> <15638.48245.84830.480715@isis.cs3-inc.com> <20020624084836.R5183@oknodo.bof.de> <15638.49692.902811.4513@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15638.49692.902811.4513@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sun, Jun 23, 2002 at 11:54:20PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But I don't think that the hash function is the problem in that case.
> In fact, there is no hash function that solves that problem, since the
> attacker can always feed you data that ruins the hash function, unless
> of course you want the function to differ from one machine to the next
> and in effect be another secret.

I agree that such secret localization is the only chance you have
against attacks on the hashes. It may even be doable.

> I suggest instead that the hash lookup be limited to a small number of
> probes.  If not found in, say, 10 probes, act like it's not there and
> the table is full.

For each packet, there is exactly one hash chain to look up. So you end
up limiting the _length_ of the single chain when creating new entries.

To the user, that would mean random breakage long before saturation,
for the sake of handling a hypothetical attack.

Thus, you also need an "am I under attack" algorithm first, and enable
that limiting behaviour only when that algorithm triggers.

In practise, the denial of service attacks I've seen fill your slowest
link, and there's nothing you can do about that except rate limit on
the _other_ side.

best regards
  Patrick
