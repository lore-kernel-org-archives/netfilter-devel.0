From: James Morris <jmorris@redhat.com>
Subject: Re: [netfilter socket hooks 1/5]: Add socket hook infrastructure
Date: Wed, 11 May 2005 19:27:11 -0400 (EDT)
Message-ID: <Xine.LNX.4.44.0505111926540.15588-100000@thoron.boston.redhat.com>
References: <Xine.LNX.4.44.0505111921390.15568-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Xine.LNX.4.44.0505111921390.15568-100000@thoron.boston.redhat.com>
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

On Wed, 11 May 2005, James Morris wrote:

> Do you need to add this struct?  It's the same as nf_hook_ops.

Don't worry, I can see nf_sk_hookfn is differnt.


- James
-- 
James Morris
<jmorris@redhat.com>
