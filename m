From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter socket hooks
Date: Thu, 12 May 2005 02:12:43 +0200
Message-ID: <42829F7B.40602@trash.net>
References: <Xine.LNX.4.44.0505111955060.15673-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
In-Reply-To: <Xine.LNX.4.44.0505111955060.15673-100000@thoron.boston.redhat.com>
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

James Morris wrote:
> What about adding an output hook to the table?  This would make it much 
> easier to manage rules.

Sure. For symetry, I would prefer only to pass packets with
skb->sk != NULL through OUTPUT and use skb->sk as socket argument
to ipt_do_table(). But rule mangement is still tricky since
only protocols which use sockets can be handled in the skfilter
table. A more radical approach would be to use the socket hooks
for filter/INPUT for all protocols with hooks - but I haven't
thought much about this yet.

Regards
Patrick
