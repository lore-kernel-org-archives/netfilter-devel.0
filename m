From: Stephen Lee <mukansai@emailplus.org>
Subject: Extremely slow network with e1000 & ip_conntrack
Date: Wed, 26 Nov 2003 17:49:58 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126174943.0AA5.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
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

Harald Welte wrote:
> On Fri, Nov 07, 2003 at 08:33:01AM +0100, Olivier wrote:
> 
> > it seems I have the same problem  as reported by other people. But I was
> > wondering if the problem is fixed, and if there is a patch available for
> > testing?
> 
> unfortunately there is no fix yet.  I seem to be unable to reproduce
> that effect on my system :(

I'm having the same problem with 2.6.0-test10.  Just loading
ip_conntrack (no rule in table) slows outbound speed to a crawl.  I am
using e1000 as well (tried both with or without NAPI), on a 1000/MT
Desktop Adaptor.

This seems to only affect traffic out of the host itself, I do not
notice slow-down of traffic route through the box, but I didn't really
stress test that.

FWIW, I was on 2.5.72 and it had the same behaviour, but ip_conntrack
was not compiled as a module so I couldn't check if it is at fault.

Stephen
