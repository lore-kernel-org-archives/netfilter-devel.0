From: Thomas Heinz <creatix@hipac.org>
Subject: Re: "Atomic" snapshot of counters
Date: Sat, 01 Feb 2003 00:28:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E3B0695.1070808@hipac.org>
References: <3E308A34.4020501@hipac.org> <20030131114514.GT9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald

Thanks for your comment.

You wrote:
>>How important is it to have such an atomic snapshot? 
> 
> From my current point of view: not that important.  My pkt_tables plans
> [which are meant to eventually replace ip_tables] also don't have this
> atomicity anymore.

Well, Michael and I had some discussion about the counter issue.
Finally, we decided to implement atomic counters but without freezing
the packet matching. We're using two counter pairs per rule. One is
a kind of overflow counter which is used after a snapshot has been
requested, i.e. all packets being machted after the snapshot has been
requested are added to the second counter. After the rules are delivered
to user space the counter pairs are "fixed", i.e. the second counter
is added to the first one and set to 0 afterwards.

This is simple. The more complicated part is based on the fact that an
insert or delete operation which appears sort of "atomic" to the user
might be expanded to several hipac rules on the kernel side.
But we also found a solution for this issue that does not require
stopping the packet matching.

BTW another topic: I've just read that you don't consider the
netfilter-devel mailing list the right place for gtk-iptables
announcements. In the past, Michael and I also posted announcements
about nf-hipac to netfilter-devel (and netfilter user mailing list) :-)
We did so because we thought (and still believe :) that nf-hipac
might be interesting for netfilter developers too (especially the
next version which will include generic support for iptables
targets/matches and user-defined chains).

Just drop us a line if you think that upcoming nf-hipac announcements
should not be posted to netfilter-devel. This is not a problem or
whatsoever ;-)


Regards,

Thomas
