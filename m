From: Simon Lodal <simonl@parknet.dk>
Subject: Re: condition for 2.6.16
Date: Sun, 23 Apr 2006 15:47:28 +0200
Message-ID: <200604231547.29009.simonl@parknet.dk>
References: <200604201919.19246.max@nucleus.it> <4447D7AA.1010602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4447D7AA.1010602@trash.net>
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

On Thursday 20 April 2006 20:49, Patrick McHardy wrote:

> We have already decided that the condition match will not be merged
> because the same thing can easily be done by adding/removing rules
> from userspace.

Conditions enable role separation between us admins.

No matter how good or fast the userspace tools are, there are cases where you 
simply do not want to (let others) run them, but it is acceptable to (let 
others) turn on/off some predefined blocks of rules.

Plus it is faster, less risky, and does not reset counters.


Simon
