From: Visham Ramsurrun <vishamr2000@yahoo.com>
Subject: building a connection tracking mechanism!!
Date: Sun, 7 Jan 2007 09:30:06 -0800 (PST)
Message-ID: <20070107173006.27453.qmail@web50906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi to all,

I want to implement a simple connection tracking
mechanism similar to that of IPTables but for the
Layer 2 filtering tool Ebtables (for the TCP packets 

only). The connection tracking mechanism will have to
keep track of mac addresses as well sequence numbers.

I wanted some help about the following:

1) what files do I have to look at in IPtables and
then inspire myself from in order to build the 
conntrack mechanism? IS there a basic version of the 

IPTables conntrack (when it was first developed and
includes only the strict minimum functionality. This
will help me understand the source code more easily 

and not get lost)?

2) What other pieces of information do you think might
be important for me to keep in mind in order to build
the system? Any tips & suggestions are most 

welcome..

Thx in advance...

Warm regards,
Visham Ramsurrun

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
