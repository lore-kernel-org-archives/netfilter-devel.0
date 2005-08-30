From: Patrick McHardy <kaber@trash.net>
Subject: Re: Implementing --log-uid in to a 2.4.x kernel
Date: Wed, 31 Aug 2005 00:31:48 +0200
Message-ID: <4314DE54.20804@trash.net>
References: <Pine.LNX.4.63.0508301507100.12743@morpheus.theendless.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kris <kris@theendless.org>
In-Reply-To: <Pine.LNX.4.63.0508301507100.12743@morpheus.theendless.org>
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

Kris wrote:
> Hi,
>     I'd like to implement this feature in to the 2.4.x kernel as it is
> currently only supported in 2.6.x.  However, I would like to know if
> anyone can shed some light on why it isn't already included?  Is this a
> futile or difficult task?  I'd think that since there is already
> owner-match support in 2.4.x it would be trivial to hack in the
> --log-uid support as the information is obviously available to the
> kernel and the netfilter API.  No?

2.4 is in pure maintenance mode, no new features are added. This is
why the patch was only included in 2.6. The original patch should be
trivial to port to 2.4.
