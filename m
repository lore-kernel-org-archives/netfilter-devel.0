From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: x_tables vs. nf-hipac
Date: Mon, 10 Oct 2005 22:31:37 +0000
Message-ID: <1128983497.3377.4.camel@localhost.localdomain>
References: <434A4B11.4030103@gmx.net>  <20051010163442.GC5627@rama>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051010163442.GC5627@rama>
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

Op ma, 10-10-2005 te 18:34 +0200, schreef Harald Welte:
> On Mon, Oct 10, 2005 at 01:05:53PM +0200, Carl-Daniel Hailfinger wrote:
> > Hi Harald,
> > 
> > you said that there is already some code for x_tables (is that
> > pkttables, and if so, doesn't the new name collide with a spreadsheet
> > layout program?). 
> 
> No, x_tables is not pkttables.  However, x_tables matches/targets will
> be incrementally changed in order to be used from
> {arp,ip,ip6,pkt}_tables _and_ nf-hipac at the same time.

Nice to see this move forward. If you want to put the arptables
userspace tool into the netfilter tree, then be my guest.
I guess we'll have to consider talking about merging ebtables into this
scheme some day...

cheers,
Bart
