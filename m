From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/8] Netfilter:  Call NAT Helper Modules Directly from
	Conntrack Modules, fixup FTP
Date: Tue, 11 Jan 2005 23:25:48 +1100
Message-ID: <1105446348.19331.70.camel@localhost.localdomain>
References: <1105438831.19331.27.camel@localhost.localdomain>
	<20050111111314.GB18568@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050111111314.GB18568@sunbeam.de.gnumonks.org>
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

On Tue, 2005-01-11 at 12:13 +0100, Harald Welte wrote:
> On Tue, Jan 11, 2005 at 09:20:31PM +1100, Rusty Russell wrote:
> > Name: Call NAT Helper Modules Directly from Conntrack Modules, fixup FTP
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Status: Tested under nfsim
> 
> Thanks, Rusty.
> 
> I agree with all your changes but the removal of the copyright and GPL
> notice ;)

Oops.

I'd really like IRC and SNMP testcases, so we can at least check I
haven't shattered them completed.

Rusty.
PS.  In my tree at the moment conntrack entries are only 192 bytes on
x86, vs. 352 in 2.6.10.  But that needs more patches 8)
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
