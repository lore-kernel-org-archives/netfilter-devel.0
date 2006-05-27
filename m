From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: nth match
Date: Sat, 27 May 2006 17:19:43 +0200
Message-ID: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

I understand Patrick wanted to integrate nth and random
into a new statistics match. That's fine with me, but why
was nth and random removed from pom without any replacement,
i.e. the new statistics match?

You're just ripping out functionality based on something which
will probably appear at some undetermined time in the future.

That's no good style, sorry. Good style would be to first write
the new match, adding it, giving it time to mature and marking
the old stuff as obsolescent, then at some time removing it.

Regards,
Torsten

(P.S.: sorry if this appears twice. I was so pissed off at the
time that I forgot to use the correct sender address)
