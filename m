From: Rene Herman <rene.herman@keyaccess.nl>
Subject: [PATCH] ip_conntrack_irc, allowance for quoted filenames
Date: Mon, 12 May 2003 03:33:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBEF9EC.4010506@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rene Herman <rene.herman@keyaccess.nl>,
 Harald Welte <laforge@gnumonks.org>
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

[ please keep me in CC, not subscribed ]

When the irssi (www.irssi.org) IRC client is asked to DCC SEND a file 
with a filename containing spaces, it does so by leaving the spaces 
intact and quoting the filename (""). ip_conntrack_irc.c:parse_dcc() 
however can't handle the embedded spaces.

I haven't checked other clients but I assume they might do the same. Is 
the attached hack (against 2.4.20) acceptable? Should this be solved 
differently and/or elsewhere?

Rene.
