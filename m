From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter socket hooks 1/5]: Add socket hook infrastructure
Date: Thu, 12 May 2005 01:27:31 +0200
Message-ID: <428294E3.9020501@trash.net>
References: <Xine.LNX.4.44.0505111921390.15568-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
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

James Morris wrote:
> On Tue, 10 May 2005, Patrick McHardy wrote:
> 
> 
>>+struct nf_sk_hook_ops
>>+{
>>+	struct list_head list;
>>+
>>+	/* User fills in from here down. */
>>+	nf_sk_hookfn *hook;
>>+	struct module *owner;
>>+	unsigned int pf;
>>+	unsigned int hooknum;
>>+	/* Hooks are ordered in ascending priority. */
>>+	int priority;
>>+};
> 
> 
> Do you need to add this struct?  It's the same as nf_hook_ops.

Unfortunately yes, the hook functions have different prototypes.

Regards
Patrick
