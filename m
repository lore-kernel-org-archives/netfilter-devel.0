From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: several small patches
Date: Mon, 16 Jun 2003 00:21:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EECF170.6070002@trash.net>
References: <3EECBFF1.2070503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <3EECBFF1.2070503@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again,

Patrick McHardy wrote:

>
> 5. ip-conntrack-expect-drop-refcnt.diff:
> drop master conntrack refcnt before setting expectant = NULL in
> remove_expectations. untested but seems to make sense.


this patch seems to fix the ip_conntrack unload-loop. I can reliably
trigger the loop by unloading ip_conntrack after unloading an
conntrack helper which is helping some connection. No problems
with this patch applied.

Best regards,
Patrick
