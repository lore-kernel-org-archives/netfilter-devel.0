From: jamal <hadi@cyberus.ca>
Subject: ANNOUNCE: tc filter extensions
Date: Sat, 4 Jan 2003 13:03:58 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030104125252.J48869__10126.799302134$1041973400@shell.cyberus.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: lartc@mailman.ds9a.nl, "" <netfilter@lists.samba.org>,
	"" <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: diffserv-general <diffserv-general@lists.sourceforge.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



I guess holidays means idle time which means idle minds which leads to
thumb twiddling which then leads to some work (which is sometimes useful)

Ive updated the traffic control patches i posted about six months ago.
Note, the current release does not break anything in tc. It is fully
backward compatible so you can choose not to use it and things will work
as they do today. Of course, it is very useful so you cant choose to
ignore it!

It's now upgraded to better than "use at your own risk" category.
tested on both uni and SMP 2.4.18 and 2.4.20.

http://www.cyberus.ca/~hadi/patches/action/

Bug reports and feedback are appreaciated.
A lot more goodies coming up, so this is just the tip. First steps are to
prove sanity of the idea.

cheers,
jamal
