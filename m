From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 11:29:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629112937.J4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.58258.483223.56527@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 03:30:42PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don,

one more thing to observe for your tests: each line from ip_conntrack
is hashed twice, with mirrored source / destination addresses. Ideally,
for a sufficiently oversized bucket count, that would be immaterial.
For the too-small-bucket case, hash list lengths should double.
With a too-bad hash function, things could get even worse.

(My apologies if you already did this doubling in your test code; my meatware
lisp parser is not very good...)

best regards
  Patrick
