From: Patrick Schaaf <bof@bof.de>
Subject: Re: review requested - spec for proposed match module
Date: Wed, 25 Dec 2002 17:20:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021225162018.GA440@oknodo.bof.de>
References: <200212250823.gBP8NYp05377@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <200212250823.gBP8NYp05377@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>  --comment string
>    This is ignored, used for commenting commands

This has no place in a single, new, specialized match. It is a GENERAL
concept to comment stuff in-line. If considered important, I would
propose an extra match '-m comment' for the purpose.

Apart from that, as there is already an 'u32' classifier in tc,
it would be nice if syntax and semantics of this new iptables
match, would be as close as possible to the tc classifier.
I don't know it too well, so I'll refrain from judging your
proposal on this.

Don't get me wrong: I do like the idea of an 'u32' match.

best regards
  Patrick
