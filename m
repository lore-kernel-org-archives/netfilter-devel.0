From: Graham Keeling <graham@equiinet.com>
Subject: iptables 1.3.1 MARK target
Date: Thu, 17 Mar 2005 16:52:48 +0000
Message-ID: <20050317165248.GB28102@ltsp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,
I'm posting this in case you guys aren't aware of it...

I'm using kernel 2.4.26.
I recently upgraded iptables from 1.2.8 to 1.3.1.
I found that the MARK target didn't work anymore.
I couldn't do --set-mark, --or-mark or --and-mark.
The error messages were;
--set-mark: invalid argument
--or-mark: kernel too old for --or-mark
--and-mark: kernel too old for --and-mark

I investigated libipt_MARK.c and found that there were two parsing functions,
parse_v0 and parse_v1, used by
struct iptables_target mark_v0
and
struct iptables_target mark_v1

void _init(void) registers both mark_v0 and mark_v1 as targets, one after the
other.

I found that by commenting out the first 'register_target()', the MARK target
worked again.

I found the following entry in the mailing archives, which contains the
patch that inserts the two different targets;
http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/017976.html

Is this something that needs fixing, or is it known about already?

Cheers,
Graham.
