From: mihai berendei <mberendei@yahoo.com>
Subject: sendmail delivery problem
Date: Thu, 24 Apr 2003 07:44:33 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424144433.4381.qmail@web9903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi!
i'm using sendmail 8.12.5 on red hat linux 8.0; in the
mail log i've found the following entries repeating:

Apr 22 12:01:59 linux sendmail[5724]: h3M81wxo005724:
timeout waiting for input from somehost during message
collect

Apr 22 12:01:59 linux sendmail[5724]: h3M81wxo005724:
from=<someone@somedomain>, size=0, class=0, nrcpts=1,
msgid=<200304220801.h3M81wxo005724@mymachine>,
proto=ESMTP, daemon=MTA, relay=samehost [someip]

Apr 22 12:01:59 linux sendmail[5724]: h3M81wxo005724:
to=<someone@mydomain>, delay=01:00:00, pri=30000,
stat=timeout waiting for input during message collect

and the message will not be delivered to it's
recipient; there are only a small number of ip's from
whom i can't receive e-mails, the rest of them
functioning normally;
why is happening this timeout waiting? the strange
thing is that message size=0 and msgid = <2003....
@mymachine instead of hismachine, hisdomain or
whatever;
it is possible that what the authors of netfilter
themselves call "criminally brain-dead ISPs or
servers" -# as i've read in this iptables tutorial:
http://iptables-tutorial.frozentux.net/iptables-tutorial.html
#- causes this timeout waiting?
 
can someone help me with this problem? please send me
your advice!
thank you in advanced!


__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
