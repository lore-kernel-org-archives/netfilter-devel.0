From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: urgent help on libiptc
Date: Mon, 10 Mar 2003 18:21:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1436569576.20030310182144@habitat-b.de>
References: <20030309190618.11970.qmail@web41007.mail.yahoo.com>
 <20030309192348.GA7177@oknodo.bof.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030309192348.GA7177@oknodo.bof.de>
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

Humm, that doesn't sound too good.
libiptc would be a great thing for directly manipulating rules. if one
has to use the command line tool, there's an annoying problem: you
would have to parse the output, which is not really a way I would love
to go (I am facing the same problem here). On the other hand, since
the commandline tool always transfers all rules between kernel and
userspace, it's awfully slow, if you have to update/modify approx 3000
rules.
The other question which remains then: Will the iptables commandline
tool be stable in the sense of: will the output be the same and will
the commandline switches stay ther same.
If any developer of iptables reads this, I'd appreciate any thoughts
on that.

Thnx

-Sven

Sunday, March 9, 2003, 8:23:48 PM, you wrote:

>> There is no tutorial connecting those two topics.

PS> This is because libiptc is not really thought of as a useful library
PS> to develop other applications; it's an internal detail of the current
PS> iptables implementation.

PS> If you need to integrate other applications with iptables, you are
PS> supposed to call the iptables, iptables-save, and iptables-restore
PS> programs, and let them worry about the details.

PS> Any program you write now to work with libiptc, is bound to fail
PS> some time in the not so far future, when the next rewrite of firewalling
PS> happens. This is already in the works, and as far as I know, there will
PS> be no attempt at library backwards compatibility.

PS> best regards
PS>   Patrick



-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
