From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter support in libnl
Date: Mon, 03 Sep 2007 11:30:59 +0200
Message-ID: <46DBD453.5040505@trash.net>
References: <46DB9716.1020400@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DB9716.1020400@snapgear.com>
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

Philip Craig wrote:
> There have been comments in the past on this list about using libnl
> for the netfilter netlink support, and since I would like to use a
> common library api for all the netlink interfaces, I decided to give
> it a go.  These patches are the result of that.
> 
> Any comments welcome, particularly about whether this is still
> something that is desired.


Very nice, I think its still desirable to avoid having to
use multiple pretty similar libraries in case you also need
to use other netlink subsystems.

And I think LGPL is a much better choice than GPL for stuff
like this.

If you want to merge this upstream, you should probably CC
Thomas.
