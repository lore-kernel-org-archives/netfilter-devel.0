From: paridhi bansal <paridhibansal@yahoo.com>
Subject: NF_DROP doesn't work
Date: Mon, 9 Dec 2002 23:29:34 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021210072934.70051.qmail@web10802.mail.yahoo.com>
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

Hi!!

I was trying to use the iptables QUEUE concept andd
let the user application allow the movement of packets
through my machine..Simply running an application that
allows all the pkts(NF_ACCEPT) works fine using
libipq...However when i try it to modify the
application to drop all the pkts(replacing NF_ACCEPT
by NF_DROP), it does not work...It still accepts all
the pkts when the application is run..Why is this
happening??

Paridhi

__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
