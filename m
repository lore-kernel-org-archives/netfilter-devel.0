From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: connection loss/pickup
Date: Mon, 8 Jul 2002 15:28:03 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15658.4595.38711.111342@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


(Trying to think about something OTHER than hashing!)

The recent message about something in conntrack that does not have to
be atomic reminds me of a question.

I'm about to implement something that cannot afford to lose track of
connections.  Is conntrack now suitable for such a thing?  If not, is
the reason well understood and easy to fix?  Or should I just start
from scratch? 

It seems to me that nat already has this character, but maybe the
nat tables data is sufficiently independent of conntrack so that you
can afford to lose conntrack data as long as you don't lose nat data?
In that case, perhaps I can do the same sort of thing.

Also, I thought that recent changes to conntrack tcp did window
checking, and window scaling can't be recovered from the middle of a
tcp connection.  So is connection pickup just never supposed to
happen?  Or under the circumstances where it does any good all sorts
of other things will break?
