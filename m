From: Brad Fisher <brad@info-link.net>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Mon, 17 May 2004 11:44:44 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A8EBFC.4DCF5E@info-link.net>
References: <Pine.LNX.4.33.0405141055450.21804-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
        Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> Sorry, but could you demonstrate the necessity/usefulness of such a
> feature? I tried to figure out at least one, but failed.

I believe Henrik's response to this pretty much sum it up - Thanks, Henrik.  I
guess the way I am currently using this match is to mark rules which are
automatically added so they can be recognized by my scripts if they need to
modify them.  I am currently modifying my rules on a rule-by-rule basis, and
have no intermediate storage of rule structure, so the tables must contain all
relevant information.  I wanted to make sure that I could manually add rules
and be certain that my scripts would not touch them, even if they did appear
to be similar.  One can build their rule structures so that most rules are in
separate application-specific chains, but there must always be hooks from some
pre-built chain to call the custom ones, and it's primarily for rules in those
chains that I use the match.  I relieves me from doing anything more
complicated than comparing for a specific pattern in the comment.  Without it,
I'd be forced to compare all elements of the rules (ie. src, dst, matches,
etc.) just to make sure it was one my script added - and even then it wouldn't
be certain.

On a related note: I had proposed at one time an 'application' match (see:
http://marc.theaimsgroup.com/?l=netfilter-devel&m=105234664704023&w=2), so I
could do the same, but the idea for the 'comment' match that was brough up
suited my needs just as well and is more flexible/general.

I don't know if the reasons mentioned above are good enough for pom inclusion,
but I'd like to see it happen.  As far as inclusion in the stock kernel, I
guess I wouldn't feel too bad if it never made it there as long as it was in
pom.

> Best regards,
> Jozsef

Thanks,
Brad Fisher
