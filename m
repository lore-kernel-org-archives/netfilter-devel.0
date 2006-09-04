From: Patrick McHardy <kaber@trash.net>
Subject: Re: check_entry & module_refcount
Date: Mon, 04 Sep 2006 15:40:22 +0200
Message-ID: <44FC2CC6.8000105@trash.net>
References: <200609041617.39950.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200609041617.39950.dim@openvz.org>
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

Dmitry Mishin wrote:
> Hello, all!
> 
> Does anybody know why there is no module_put() on the error way after failed 
> standard_check() call in the check_entry() function? Previous xt_find_target()
> calls try_module_get() for all targets, without special checks for
> standard_target.

The standard target doesn't have a module reference, so the counter
isn't really increased. While rules are present the tables have
references to ip_tables anyway, so its not needed.
