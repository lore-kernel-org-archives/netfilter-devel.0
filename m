From: Eric Leblond <eric@inl.fr>
Subject: Re: Changing netfilter rules from a kernel module
Date: Thu, 23 Sep 2004 14:45:15 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095943514.3478.28.camel@coati>
References: <20040922185326.26099.qmail@web50004.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040922185326.26099.qmail@web50004.mail.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

An alternative to portknocking is to use NuFW : http://www.nufw.org.

You could even use the nufw code as start to a real portknocking system
:
QUEUE packet on toc toc ports and target ports
test order in userspace and send ACCEPT if tests succeed.

On Wed, 2004-09-22 at 20:53, spid spid wrote:
> I've written a netfilter match for port knocking.  I
> need a way of modifying rules from a kernel module. 
> Currently, what I have is a server that reads from
> /proc/net/portknock to see which knocks are open and
> which knocks are closed.
> 
> Is changing [a] rule(s) from a kernel module currently
> possible?
> 
> If so, is there any reason not do to it this way?
> 
> it's not a port knocking question, but you may visit
> www.portknocking.org to view information about this
> idea.
> 
> Thanks.
> 
> 
> 
> 		
> _______________________________
> Do you Yahoo!?
> Declare Yourself - Register online to vote today!
> http://vote.yahoo.com
> 
