From: Patrick Schaaf <bof@bof.de>
Subject: Re: differences between 2.4.19 and 2.4.20?
Date: Tue, 12 Aug 2003 10:14:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030812081404.GA350@oknodo.bof.de>
References: <3F381BFB.6060805@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Srinivas Kommu <kommu@hotmail.com>
Content-Disposition: inline
In-Reply-To: <3F381BFB.6060805@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 11, 2003 at 03:43:07PM -0700, Srinivas Kommu wrote:
> Is there a major difference in the netfilter functionality in the 2.4.19 
> and 2.4.20 kernels? What are the differences?
> 
> Is there a general way to find out?

Yes. It's called 'diff', the result is a 'patch file'. There is also
the usual overall ChangeLog:

http://www.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.20

The major change, from the ChangeLog, was this:

  o [NETFILTER]: Backport newnat infrastructure to 2.4.x

IIRC, you want to use the newest 2.4.21, and 2.4.20 had its share
of bugs in the area of netfilter. But I'm not sure: I avoided 2.4.20
for some reason, but don't remember specifics.

best regards
  Patrick
