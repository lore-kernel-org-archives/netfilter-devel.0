From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: urgent help on libiptc
Date: Mon, 10 Mar 2003 19:01:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <378960224.20030310190135@habitat-b.de>
References: <20030309190618.11970.qmail@web41007.mail.yahoo.com>
 <20030309192348.GA7177@oknodo.bof.de> <1436569576.20030310182144@habitat-b.de>
 <20030310174217.GA8066@oknodo.bof.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030310174217.GA8066@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Patrick,

Thnx for the answer, but there's some things I'd like to add ...

Monday, March 10, 2003, 6:42:17 PM, you wrote:

>> Humm, that doesn't sound too good.

PS> Too bad.

>> libiptc would be a great thing for directly manipulating rules. if one
>> has to use the command line tool, there's an annoying problem: you
>> would have to parse the output, which is not really a way I would love
>> to go (I am facing the same problem here).

PS> This is true. Note that iptables-save format is designed to be a bit more
PS> sane to parse than 'iptables -L' output. Especially, there is already a
PS> working parser, called iptables-restore. Hope this helps some.

This might be an interesting approach, I'll have to have a closer look
on that ...

>> On the other hand, since
>> the commandline tool always transfers all rules between kernel and
>> userspace, it's awfully slow, if you have to update/modify approx 3000
>> rules.

PS> This will be exactly the same when you use libiptc - it is the
PS> (admittedly broken) way the kernel/user interface works, now.
PS> This is the main driver which pushes the rewrite that is currently
PS> happening.

Humm, not exactly, with the commandline tool I can alter one rule and
it commits ... when I use libiptc this is only done after updating all
the rules. In comparison to the load/save feature, of course, you are
absolutely right, from what I understood.

>> The other question which remains then: Will the iptables commandline
>> tool be stable in the sense of: will the output be the same and will
>> the commandline switches stay ther same.
>> If any developer of iptables reads this, I'd appreciate any thoughts
>> on that.

PS> The 'iptables -L' output, and the 'iptables' commandline interface,
PS> will change, or so I've been told. Especially the commandline interface:
PS> it is too flexible (permits you lots of variants in the order of options).

PS> Things may be better with the iptables-save / iptables-restore file format,
PS> or so I hope.

that all doesn't sound too promising, this really is a pitty :-(. An
abstract Interface is always a thing one appreciates, at least if it's
to some extend 'stable' ... but I guess this is just life ;-).

PS> Note that I'm not involved in those rewrite activities, so all this
PS> is second hand information. And I do think that the questions deserve
PS> a reliable answer, regarding IF, WHEN, and HOW such a committment CAN
PS> be made.

I surely understand that, I really didn't expect an answer on that, I
was rather interested in the future development and if there's plans
to either keep command line switches, or maybe providing an abstract
interface for heavywieght applications, that need to tweak a lot of
rules. Thanx for that long and honest answer, it helped out on some
further considerations concerning the software I am trying to write.

PS> best regards
PS>   Patrick

Anyway, it would be nice if one of those folks rewriting/redesigning
everything could drop a short note/comment on this ...

So long ...

-- 
Best regards,
 Sven                            mailto:DarKRaveR@habitat-b.de
