From: Brad Fisher <brad@info-link.net>
Subject: Re: rfc on new match type
Date: Thu, 08 May 2003 12:05:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBA8E77.EF904A64@info-link.net>
References: <3EB988B8.707B6111@info-link.net> <20030508054551.GA25328@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

> With a string instead of an id, this is exactly the 'comment' match
> that I proposed before, but with a less general application (pun
> intended) in mind.

A comment match would serve my purposes just as well.  I could always use a
(hopefully) unique commenting style for a given app, and match on that style.

> You can, somewhat, emulate it today, with a pattern like this:
>
>         iptables -A chain -s 0.0.0.0 -m string --string "start APP1"
>         iptables -A chain ...
>         iptables -A chain ...
>         iptables -A chain -s 0.0.0.0 -m string --string "end APP1"

So as I understand the above example, all rules added by the application would
need to be bracketed by the string match rules?  How would you handle the case
where your application inserts rules into a chain at arbitrary spots (say
before other possibly pre-existing rules which may match the same general
criteria, but in a broader sense).  You could bracket each rule with the two
string matches, but that seems undesirable.  And that all relies on all
applications respecting such bracketing.

Anyway, not complaining about the response.  Your suggestion is excellent, but
doesn't quite meet my needs.  I do believe that if I end up implementing a
match like this, I will use the above mentioned "comment" form, so it can have
a more general application as suggested.

Thanks!

-Brad
